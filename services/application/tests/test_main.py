import pytest

from app.main import greeting

@pytest.mark.asyncio
async def test_greeting_function():
    result = await greeting()
    assert result == {"greeting": "Local"}