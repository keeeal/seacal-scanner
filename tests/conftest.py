from pathlib import Path

import pytest


@pytest.fixture()
def cad_path() -> Path:
    return Path("src") / "cad"


@pytest.fixture()
def logs_path() -> Path:
    return Path("output") / "logs"


@pytest.fixture()
def parts_path() -> Path:
    return Path("output") / "parts"
