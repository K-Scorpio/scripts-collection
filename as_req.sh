#!/bin/bash
filter=$(tshark -r $1 -Y "kerberos.msg_type == 10 && kerberos.cipher && kerberos.realm && kerberos.CNameString" -T fields -e kerberos.CNameString -e kerberos.realm -e kerberos.cipher -E separator=$ )

for i in $(echo $filter | tr ' ' '\n') ; do

    echo "\$krb5pa\$18\$$i"

done