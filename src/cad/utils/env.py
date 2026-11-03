from os import getenv


def getenv_bool(key: str, *, default: bool = False) -> bool:
    value = getenv(key)
    if value is None:
        return default
    if value.lower() in ("1", "true", "yes", "on"):
        return True
    if value.lower() in ("0", "false", "no", "off"):
        return False
    return default


def getenv_int(key: str, *, default: int = 0) -> int:
    value = getenv(key)
    if value is None:
        return default
    try:
        return int(value)
    except ValueError:
        return default


def getenv_float(key: str, *, default: float = 0.0) -> float:
    value = getenv(key)
    if value is None:
        return default
    try:
        return float(value)
    except ValueError:
        return default
