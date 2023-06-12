from pathlib import Path

import pytest


@pytest.fixture()
def parts_config_file() -> Path:
    return Path("src") / "cad" / "parts.yaml"


@pytest.fixture()
def cad_root_dir() -> Path:
    return Path("src") / "cad" / "scanner"


@pytest.fixture()
def parts_output_dir() -> Path:
    return Path("output") / "parts"


@pytest.fixture()
def logs_dir() -> Path:
    return Path("output") / "logs"
