from datetime import timedelta
from pathlib import Path
from typing import Any
from yaml import safe_load


def has_suffix(path: Path, suffix: str) -> bool:
    return path.suffix.lower() == suffix.lower()


def get_stems(root: Path, suffix: str) -> list[str]:
    return [f.stem for f in root.iterdir() if has_suffix(f, suffix)]


def read_log_file(log_file: Path) -> dict[str, Any]:
    with open(log_file) as f:
        data = dict(
            map(str.strip, line.split(":", maxsplit=1))
            for line in f.readlines()
            if ":" in line
        )

    for key, value in data.items():
        if key in [
            "CGAL cache size in bytes",
            "CGAL Polyhedrons in cache",
            "Edges",
            "Facets",
            "Geometries in cache",
            "Geometry cache size in bytes",
            "Halfedges",
            "Halffacets",
            "Vertices",
            "Volumes",
        ]:
            data[key] = int(value)
        elif key == "Simple":
            data[key] = value == "yes"
        elif key == "Total rendering time":
            h, m, s = map(float, value.split(":"))
            data[key] = timedelta(hours=h, minutes=m, seconds=s)

    return data


def get_top_level_modules(scad_file: Path) -> set[str]:
    with open(scad_file) as f:
        lines = f.readlines()

    prefix = "module "

    return {
        line[len(prefix) :].split("(", maxsplit=1)[0]
        for line in lines
        if line.startswith(prefix)
    }


def test_cad_structure(cad_root_dir: Path):
    module_names = []

    for scad_file in cad_root_dir.rglob("*.scad"):
        module_name = (
            scad_file.parent.stem.replace("-", "_")
            if scad_file.stem == "__subassembly__"
            else scad_file.stem.replace("-", "_")
        )
        assert module_name in get_top_level_modules(scad_file)
        module_names.append(module_name)

    assert len(module_names) == len(set(module_names))


def test_no_fn_usage(cad_root_dir: Path):
    for scad_file in cad_root_dir.rglob("*.scad"):
        with open(scad_file) as f:
            lines = f.readlines()

        assert not any(line.strip().startswith("$fn") for line in lines)


def test_parts_config(parts_config_file: Path):
    # TODO: Use pydantic for this
    with open(parts_config_file) as f:
        parts_config = safe_load(f)

    assert isinstance(parts_config, dict)
    assert len(parts_config) > 0


def test_one_stl_per_part(parts_config_file: Path, parts_output_dir: Path):
    with open(parts_config_file) as f:
        parts_config = safe_load(f)

    stl_stems = get_stems(parts_output_dir, suffix=".stl")
    assert set(parts_config) == set(stl_stems)


def test_one_volume_per_part(parts_config_file: Path, logs_dir: Path):
    with open(parts_config_file) as f:
        parts_config = safe_load(f)

    for part_name in parts_config:
        log_data = read_log_file(logs_dir / f"{part_name}.log")
        assert log_data["Volumes"] == 2
