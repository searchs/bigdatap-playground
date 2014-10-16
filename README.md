##BigData Projects
+ Scripts for testing unstructured data using any language
+ BigData:  Volume, Variety, Velocity

##Tools - Flavours and Addons:
- Hadoop
- Hive
- Pig
- ZooKeeper
- Spark
- Whirr
- Sqoop
- Impala(mpp)
- Flume
- Oozie
- HBase
- HCatalog

##Monitoring Hadoop
- Hardware Failures
- Disks (I/O, failures, permissions, RAM usage, CPU usage, JVM details) - tool Cloudera Manager

##Hadoop EcoSystem
- NameNode
- Secondary NameNode
- JobTracker
- DataNode(s)
- TaskTracker(s)

##Web GUIs
- Hue (end users' access to BigData backend)
- Cloudera Manager(BigData admins)


##Types of Analysis
- Recommendation Engines
- Index Building
- Text Mining/Pattern Recognition
- Risk Assessment/Threat Analysis
- Predictive Analysis
- Fault/Error Detection

##Common Usecases
- Recommendations (e.g. Yelp)
- Ad Targeting
- Fraud Detection
- Image Processing
- *Article: 10 Hadoopable problems by Jeff Hammerbacher*

##Hadoop Pillars
- Storage (provided by HDFS)
   -- Distributed (striped)
   -- Redundant (mirrored)
- Processing 
   -- MapReduce
   
##Setup Recommendations
-  User Cloudera (Cloudera Manger, package installs)
-  Use Linux (Centos 5+)
-  Do not use RID or LVM disks
-  Optimize BIOS settings, install NTP
-  Validate all hardware before using in production


##AWS EMR (Elastic Map Reduce) - sporadic bigdata needs
-  Abstracts out cluster setup and management
-  Redcue costs
-  Integrates to AWS
-  Different Architecture
-  Datastore pull/push to (RDS, DynamoDB, S3)
-  Derived data can be stored in RedShift (using AWS DataPipelines)
-  Data can be pre-processed with Amazon Kinesis

####EMR Usecases
- Already AWS customer
- Sporadic MapReduce needs
- POC Hadoop
- Ease of use

###Testing Ideas
-  Test the code
-  Test the data



