from pathlib import Path
from typing import Any

from tests.cad.utils import read_log_file
from tests.utils import get_stems


def test_no_fn_usage(cad_root_dir: Path):
    for scad_file in cad_root_dir.rglob("*.scad"):
        with open(scad_file) as f:
            lines = f.readlines()

        assert not any(line.strip().startswith("$fn") for line in lines)


def test_parts_config(parts_config: dict[str, dict[str, Any]]):
    assert isinstance(parts_config, dict)
    assert len(parts_config) > 0

    for key, value in parts_config.items():
        assert isinstance(key, str)
        assert isinstance(value, dict)
        assert all(isinstance(k, str) for k in value.keys())


def test_one_stl_per_part(parts_config: dict[str, dict[str, Any]], parts_dir: Path):
    stl_stems = get_stems(parts_dir, suffix=".stl")
    assert set(parts_config) == set(stl_stems)


def test_one_volume_per_part(parts_config: dict[str, dict[str, Any]], parts_dir: Path):
    for part_name in parts_config:
        log_data = read_log_file(parts_dir / f"{part_name}.log")
        if "Volumes" in log_data:
            assert log_data["Volumes"] == 2
