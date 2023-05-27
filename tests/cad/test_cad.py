from pathlib import Path
from typing import Any, Union
from datetime import timedelta


def has_suffix(path: Union[Path, str], suffix: str) -> bool:
    return Path(path).suffix.lower() == suffix.lower()


def is_dunder(path: Union[Path, str]) -> bool:
    stem = Path(path).stem
    return stem == f"__{stem.strip('_')}__"


def get_cad_stems(cad_path: Union[Path, str]) -> list[str]:
    return [
        f.stem
        for f in Path(cad_path).iterdir()
        if has_suffix(f, ".scad") and not is_dunder(f)
    ]


def read_log_file(log_file: Union[Path, str]) -> dict[str, Any]:
    with open(log_file) as f:
        data = dict(
            map(str.strip, line.split(":", maxsplit=1)) for line in f.readlines()
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


def test_one_stl_per_cad_file(cad_path: Path, parts_path: Path):
    cad_stems = get_cad_stems(cad_path)
    stl_stems = [f.stem for f in parts_path.iterdir() if has_suffix(f, ".stl")]

    for cad_stem in cad_stems:
        assert cad_stem in stl_stems


def test_one_log_per_cad_file(cad_path: Path, logs_path: Path):
    cad_stems = get_cad_stems(cad_path)
    log_stems = [f.stem for f in logs_path.iterdir() if has_suffix(f, ".log")]

    for cad_stem in cad_stems:
        assert cad_stem in log_stems


def test_one_volume_per_cad_file(cad_path: Path, logs_path: Path):
    cad_stems = get_cad_stems(cad_path)

    for cad_stem in cad_stems:
        log_data = read_log_file(logs_path / f"{cad_stem}.log")
        assert log_data["Volumes"] == 2
