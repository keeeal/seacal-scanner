from pathlib import Path
from typing import Any
from datetime import timedelta


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


def test_one_stl_per_cad_file(parts_source_dir: Path, parts_output_dir: Path):
    scad_stems = get_stems(parts_source_dir, suffix=".scad")
    stl_stems = get_stems(parts_output_dir, suffix=".stl")

    for scad_stem in scad_stems:
        assert scad_stem in stl_stems


def test_one_log_per_cad_file(parts_source_dir: Path, logs_dir: Path):
    scad_stems = get_stems(parts_source_dir, suffix=".scad")
    log_stems = get_stems(logs_dir, suffix=".log")

    for scad_stem in scad_stems:
        assert scad_stem in log_stems


def test_one_volume_per_cad_file(parts_source_dir: Path, logs_dir: Path):
    scad_stems = get_stems(parts_source_dir, suffix=".scad")

    for cad_stem in scad_stems:
        log_data = read_log_file(logs_dir / f"{cad_stem}.log")
        assert log_data["Volumes"] == 2
