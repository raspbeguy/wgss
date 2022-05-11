from datetime import datetime, timedelta
from babel.dates import format_timedelta

def date(t):
    return datetime.fromtimestamp(t)

def reldate(t):
    return format_timedelta(timedelta(seconds=datetime.now().timestamp() - t), locale='fr_FR')

def reldate_raw(t):
    return datetime.now().timestamp() - t

def prettysize(t):
    suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB']
    i = 0
    while t >= 1024 and i < len(suffixes)-1:
        t /= 1024.
        i += 1
    f = ('%.2f' % t).rstrip('0.')
    return '%s %s' % (f, suffixes[i])
