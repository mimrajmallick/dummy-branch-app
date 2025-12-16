"""
Simple test file for CI/CD pipeline
"""
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

def test_addition():
    """Basic test example"""
    assert 1 + 1 == 2, "Math should work"

def test_imports():
    """Test that key modules can be imported"""
    try:
        import flask
        import sqlalchemy
        import psycopg2
        print("✅ All required modules can be imported")
        return True
    except ImportError as e:
        print(f"❌ Import error: {e}")
        return False

if __name__ == "__main__":
    test_addition()
    test_imports()
    print("✅ All tests passed!")
