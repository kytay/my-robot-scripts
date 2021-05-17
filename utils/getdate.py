from datetime import datetime

now = datetime.now()
datestring = now.strftime("%Y%m%d_%H%M")
print(datestring)