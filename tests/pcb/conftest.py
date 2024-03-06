from csv import reader
from pathlib import Path

import pytest


@pytest.fixture()
def layers_config_file() -> Path:
    return Path("src") / "pcb" / "layers.csv"


@pytest.fixture()
def layers_config(layers_config_file: Path) -> list[str]:
    with open(layers_config_file, newline="") as f:
        return [i for row in reader(f) for i in row]


@pytest.fixture()
def gerbers_dir() -> Path:
    return Path("build") / "gerbers"


@pytest.fixture()
def gerber_file_prefix() -> str:
    return "seacal-scanner-"
