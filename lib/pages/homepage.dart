//import 'dart:html';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:newproject2/controllers/db_helper.dart';
import 'package:newproject2/modals/transaction_modal.dart';
import 'package:newproject2/pages/add_transactions.dart';
import 'package:newproject2/pages/widgets/confirmDialogue.dart';
import 'package:newproject2/static.dart' as Static;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DbHelper dbHelper= DbHelper();
  DateTime today= DateTime.now();
  late SharedPreferences preferences;
  late Box box;
  int totalBalance =0;
  int totalIncome =0;
  int totalExpense =0;
  List<FlSpot> dataset =[];

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  List<FlSpot> getPlotPoints(List<TransactionModal> entireData){
    dataset=[];
    // entireData.forEach((key, value) {
    //   if(value["type"]=="Expense" && (value["date"] as DateTime).month ==today.month){
    //     dataset.add(FlSpot(
    //         (value["date"] as DateTime).day.toDouble()  ,
    //         (value["amount"] as int).toDouble()),);
    //   }
    // });
    List tempDataset = [];

    for(TransactionModal data in entireData)
      {
        if(data.date.month== today.month && data.type=="Expense") {
          tempDataset.add(data);
        }
      }
    tempDataset.sort((a,b)=> a.date.day.compareTo(b.date.day));
    for(var l=0;l<tempDataset.length;l++)
      {
        dataset.add(FlSpot(tempDataset[l].date.day.toDouble(), tempDataset[l].amt.toDouble()));
      }
    return dataset;
  }
  
  getPreferences() async{
    preferences= await SharedPreferences.getInstance();
  }

  Future<List<TransactionModal>> fetch() async{
    if(box.values.isEmpty){
      return Future.value([]);
    }
    else{
      List<TransactionModal> items=[];
      box.toMap().values.forEach((element) {
        items.add(TransactionModal(
          element["amount"] as int,
          element["date"] as DateTime,
          element["note"],
          element["type"],
        ));
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    box= Hive.box('money');
  }

  getTotalBalance(List<TransactionModal> entireData){
     totalBalance =0;
     totalIncome =0;
     totalExpense =0;
    // entireData.forEach((key, value) {
    //
    //   if (value["type"] == "Expense"){
    //     totalBalance -= (value['amount'] as int);
    //     totalExpense += (value['amount'] as int);
    //   }
    //   else{
    //     totalBalance += (value['amount'] as int);
    //     totalIncome += (value['amount'] as int);
    //   }
    //
    // });
     for (TransactionModal data in entireData) {
       if (data.date.month == today.month) {
         if (data.type == "Income") {
           totalBalance += data.amt;
           totalIncome += data.amt;
         } else {
           totalBalance -= data.amt;
           totalExpense += data.amt;
         }
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),

      backgroundColor: Color(0xffe2e7ef),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=> AddTransactions(),
          ),
          ).whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Static.PrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(16.0,),
        ),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<List<TransactionModal>>(
        future: fetch(),
        builder: (context, snapshot) {
          if(snapshot.hasError)
            return Center(child: Text("Unexpected Error"),);
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
              return Center(child: Text("No Values Found"),);
            }
             getTotalBalance(snapshot.data!);
             getPlotPoints(snapshot.data!);
            return ListView(
              children: [
                Padding(padding: EdgeInsets.all(12.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0,),
                            color: Colors.white70,
                          ),
                          child: CircleAvatar(
                            maxRadius: 32.0,
                            child: Image.asset("assets/face.png",
                              width: 64.0,),
                          ),
                        ),
                        SizedBox(width: 8.0,),
                        Text("Welcome ${preferences.getString('name')}",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Static.PrimaryMaterialColor[800],
                        ),
                        ),
                      ],
                    ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0,),
                          color: Colors.white70,
                        ),
                        padding: EdgeInsets.all(12.0,),
                        child: Icon(Icons.settings,
                        size: 32.0,
                        color: Color(0xff3E454C),
                        ),
                      ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(12.0,),
                  child: Container(
                    decoration: BoxDecoration(gradient: LinearGradient(
                        colors:[
                          Static.PrimaryColor,
                          Colors.blueAccent,
                        ],
                    ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(24.0
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 8.0),
                    child: Column(
                      children: [
                        Text("Total Balance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12.0,),
                        Text("Rs $totalBalance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12.0,),
                        Padding(padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween
                            ,
                            children: [
                              cardIncome(totalIncome.toString(),),
                              cardExpense(totalExpense.toString(),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(padding: const EdgeInsets.all(15.0,),
                  child: Text(
                    "Expenses",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

               dataset.length<2 ? Container(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0,),
                  boxShadow: [
                  BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 6,
                  offset: Offset(0,4),
                  ),
                  ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
                  margin: EdgeInsets.all(12.0,),
                  child: Text("No Enough values to render a chart!",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                    ),),
                  ) : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0,),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0,4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
                  margin: EdgeInsets.all(12.0,),
                  height: 400,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false,),
                      lineBarsData: [
                        LineChartBarData(
                          spots: getPlotPoints(snapshot.data!),
                          isCurved: false,
                          barWidth: 2.0,
                          colors: [Static.PrimaryColor,],
                        ),
                    ],)
                  ),
                ),

                Padding(padding: const EdgeInsets.all(15.0,),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context , index) {
                    TransactionModal dataAtIndex;
                    try {
                      // dataAtIndex = snapshot.data![index];
                      dataAtIndex = snapshot.data![index];
                    } catch (e) {
                      // deleteAt deletes that key and value,
                      // hence makign it null here., as we still build on the length.
                      return Container();
                    }
                    if(dataAtIndex.type=="Income"){
                      return incomeTile(
                          dataAtIndex.amt,
                          dataAtIndex.note,
                          dataAtIndex.date,
                          index,
                      );
                    }else {
                      return expenseTile(
                          dataAtIndex.amt,
                          dataAtIndex.note,
                          dataAtIndex.date,
                          index,
                      );
                    }
                  },
                ),
                SizedBox(height: 50.0,),
              ],
            );
          } else return Center(child: Text("Unexpected Error"),);
        }
      ),
    );
  }


  Widget cardIncome(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0,
            ),
          ),
          padding: EdgeInsets.all(12.0,),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(right: 8.0,),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Text("Income",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white70,
          ),
          ),
            Text(value,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
        ],
        ),
      ],
    );
  }

  Widget cardExpense(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0,
            ),
          ),
          padding: EdgeInsets.all(12.0,),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(right: 8.0,),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Expense",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white70,
              ),
            ),
            Text(value,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget expenseTile(int value, String note,DateTime date,int index){
    return InkWell(
      onLongPress: () async {
        bool? answer= await showConfirmDialog(context, "Warning", "Do You want to delete this record?");
        if(answer!=null && answer){
          dbHelper.deleteData(index);
          setState(() {
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Color(0xffced4eb),
          borderRadius: BorderRadius.circular(8.0,),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_up_outlined,
                      size: 28.0,
                      color: Colors.red[700],
                    ),
                    SizedBox(width: 6.0,),
                    Text("Expense",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(" ${date.day} ${months[date.month-1]}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("- $value",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.0,),
                Text(" $note",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
}

  Widget incomeTile(int value, String note,DateTime date,int index){
    return InkWell(
      onLongPress: () async {
        bool? answer= await showConfirmDialog(context, "Warning", "Do You want to delete this record?");
        if(answer!=null && answer){
          dbHelper.deleteData(index);
          setState(() {
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Color(0xffced4eb),
          borderRadius: BorderRadius.circular(8.0,),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_down_outlined,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    SizedBox(width: 6.0,),
                    Text("Income",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(" ${date.day} ${months[date.month-1]}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("+ $value",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.0,),
                Text(" $note",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
