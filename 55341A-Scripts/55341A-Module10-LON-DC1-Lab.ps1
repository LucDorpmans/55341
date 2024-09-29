# 20740
# Module 10
# LON-DC1

Start "HTTP://LON-SVR1"
Start "HTTP://LON-SVR2"

Start "HTTP://LON-SVR2:5678/"

#Either from LON-SVR1 or locally:
Add-DNSServerResourceRecordA –zonename adatum.com –name LON-NLB –Ipv4Address 172.16.0.42

Start "HTTP://LON-NLB"
Start "HTTP://LON-NLB:5678"

Start "HTTP://LON-SVR2:5678/"