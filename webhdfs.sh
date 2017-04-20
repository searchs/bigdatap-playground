# PUT
# step 1:
# curl -i -X PUT "http://<HOST>:<PORT>/webhdfs/v1/<PATH>?op=CREATE
#                    [&overwrite=<true |false>][&blocksize=<LONG>][&replication=<SHORT>]
#                    [&permission=<OCTAL>][&buffersize=<INT>]"
#
# step 2:
# curl -i -X PUT -T <LOCAL_FILE> "http://<DATANODE>:<PORT>/webhdfs/v1/<PATH>?op=CREATE..."
# MKDIR
# curl -i -X PUT "http://<HOST>:<PORT>/webhdfs/v1/<PATH>?op=MKDIRS[&permission=<OCTAL>]"

###########################################
#      INGESTION SCRIPT                   #
#                                         #
###########################################

logger ~/logs/to_hdfs.log

if [[ -z $1 ]]; then
     current_date=`date +%Y%m%d`
else
   current_date="$1"
fi

WEBHDFS_HOST=hadoop_instance_domain
WEBHDFS_PORT=50070
HDFS_PATH=/user/$USER/input/${current_date}
HDFS_USER="user.name=${USER}"
OVERWRITE_OPT="overwrite=true"
#SRC_FILE=file_name.txt
SRC="-"
SRC_FILENAME="source_file_input_${current_date}.csv"
REDIRECT_URL_outfile=URL_OUT.txt
ACK_outfile=ack.txt

set -x
curl -s -i -X PUT "http://${WEBHDFS_HOST}:${WEBHDFS_PORT}/webhdfs/v1${HDFS_PATH}?${HDFS_USER}&op=MKDIRS${PERMISSION_OCTAL}" | tee $ACK_outfile
REDIRECT_URL=$(curl -s -i -X PUT "http://${WEBHDFS_HOST}:${WEBHDFS_PORT}/webhdfs/v1${HDFS_PATH}/${SRC_FILENAME}?${HDFS_USER}&op=CREATE&${OVERWRITE_OPT}${PERMISSION_OCTAL}" | tr -d "\r" | tee $REDIRECT_URL_outfile | grep "Location:" | cut -d" " -f2)

echo "<$REDIRECT_URL>"
date | curl -s -i -X PUT -T $SRC "$REDIRECT_URL" | tee $ACK_outfile

grep "Created" $ACK_outfile || echo "Process failed!"

curl -i -X PUT -T "/home/${USER}/input/${SRC_FILENAME}" "${REDIRECT_URL}"
