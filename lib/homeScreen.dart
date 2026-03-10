import 'package:flutter/material.dart';

class Task{
  String title;
  int completed;
  int total;
  Task({required this.title,required this.completed,required this.total});
}

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState()=>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List<Task> tasks=[
     Task(title: "Sketching", completed: 2, total: 2),
     Task(title: "WireFraming", completed: 0, total: 4),
     Task(title: "Visual Design", completed: 1, total: 3),
  ];

  TextEditingController taskController=TextEditingController();

  void showAddTaskForm(){
    showModalBottomSheet(
      context:context,
      builder:(context){
        return Padding(
          padding:EdgeInsets.all(20),
          child:Column(
            mainAxisSize:MainAxisSize.max,
            children:[
              Text('Add Task',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold),
              ),
              SizedBox(height:20),
              TextField(controller:taskController,decoration:InputDecoration(hintText:"Enter task name",border:OutlineInputBorder(),),
              ),
              SizedBox(height:20),
              ElevatedButton(
                onPressed:(){
                  setState((){
                    tasks.add(
                      Task(title:taskController.text,completed:0,total:1),
                    );
                  });
                  taskController.clear();
                  Navigator.pop(context);
                },
                child:Text("Add Task"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget categoryCard(IconData icon,String title,String task,Color color){
    return Container(
      width:119,
      height:137,
      padding:EdgeInsets.all(10),
      decoration:BoxDecoration(
        color:color,
        borderRadius:BorderRadius.circular(15),
      ),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Icon(icon,color:Colors.white,size:28),
          Spacer(),
          Text(
            title,
            style:TextStyle(
              color:Colors.white,
              fontWeight:FontWeight.bold,
              fontSize:16,
            ),
          ),
          SizedBox(height:4),
          Text(task,style:TextStyle(
            color:Colors.white70,
            fontSize:12,
          ),
          ),
          Icon(Icons.add,size:16,color:Colors.white),
        ],
      ),
    );
  }

 Widget taskItem(IconData icon,String title,String tasks,String taskNumber){
  return Padding(
    padding:EdgeInsets.symmetric(horizontal:30),
    child:Row(
      children:[
        Container(width:40,
        height:40,
        decoration:BoxDecoration( color:Colors.purple.shade50,),
        child:Icon(icon,color:Colors.purple),
        ),
        SizedBox(width:20),
        Expanded(
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              Text(
                title,
                style: TextStyle(
                  fontSize:16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tasks,style:TextStyle(
                  fontSize:11,color:Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
                padding:EdgeInsets.symmetric(horizontal:8,vertical:4),
                decoration:BoxDecoration(
                  color:Colors.purple.shade50,
                ),
                child:Text(taskNumber,style:TextStyle(fontSize:11,color:Colors.purple,),),
              ),
      ],
    ),
  );
 }

  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton:FloatingActionButton(
        onPressed:showAddTaskForm,
        backgroundColor:Colors.purple,
        child:Icon(Icons.add),
      ),
      body: Stack(
  children: [

    // Background
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.purpleAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),

    // Top content
    SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        )),
                    Text("Jhon Doe",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/profile.png",
                    width: 57,
                    height: 57,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search....",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey),
                ],
              ),
            ),

            SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Category",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  categoryCard(Icons.brush, "Design", "Tasks 5", Colors.pink),
                  SizedBox(width: 10),
                  categoryCard(Icons.meeting_room, "Meeting", "Tasks 2", Colors.orange),
                  SizedBox(width: 10),
                  categoryCard(Icons.school, "Learning", "Tasks 1", Colors.green),
                ],
              ),
            ),

            SizedBox(height: 300), // space behind sheet
          ],
        ),
      ),
    ),

    // Bottom draggable sheet
    DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Text(
                "Today's Task",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),
              ...tasks.map((task){
                  return Column(
                   children: [
                       taskItem(
                      Icons.brush,task.title,"completed ${task.completed}",task.total.toString(),
                    ),
                  SizedBox(height:10),
                   ],
                  );
              }).toList(),
            ],
          ),
        );
      },
    ),
  ],
),
);
}
}