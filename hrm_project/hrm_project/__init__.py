import pymysql
pymysql.version_info = (2, 2, 8, "final", 0)  # Fake version to bypass Django check
pymysql.install_as_MySQLdb()
from .celery import app as celery_app

__all__ = ('celery_app',)

