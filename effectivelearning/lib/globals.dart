library my_proj.globals;

var glob = new Map<String, dynamic>();
var videoCheck = new Map<String, dynamic>();
var vDownProg = new Map<String, double>();
List<String> vCheck;
List<String> downloadQueueUrl = new List();
List<String> downloadQueueLesson = new List();
List<int> downloadQueueFlag = new List(); // 0: Not Downloaded, 1: Download Started, 2: Downloaded
List<double> downloadPercent = new List();
int downloadPos = 0;



Function() onRedrawCourse;