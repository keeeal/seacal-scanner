from pathlib import Path

import pytest


@pytest.fixture()
def parts_config_file() -> Path:
    return Path("cad") / "parts.yaml"


@pytest.fixture()
def cad_root_dir() -> Path:
    return Path("cad") / "scanner"


@pytest.fixture()
def parts_output_dir() -> Path:
    return Path("output") / "parts"
