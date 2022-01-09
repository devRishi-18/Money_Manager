import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newproject2/controllers/db_helper.dart';
import 'package:newproject2/static.dart' as Static;

class AddTransactions extends StatefulWidget {
  const AddTransactions({Key? key}) : super(key: key);

  @override
  _AddTransactionsState createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {

  //
    int? amount;
    String note= "Some Expense";
    String type="Income";
    DateTime selectedDate= DateTime.now();
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

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2001, 1),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
        backgroundColor: Color(0xffe2e7ef),

      body: ListView(
        padding: EdgeInsets.all(
          12.0,
        ),


        children: [
          SizedBox(
            height: 20.0,
          ),
          Text("Add Transaction",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(
            height: 20.0,
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Static.PrimaryColor,
                  borderRadius: BorderRadius.circular(16.0,
                  ),
                ),
                padding: EdgeInsets.all(
                  12.0,
                ),

                child: Icon(
                  Icons.attach_money,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),

              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "0",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val){
                    try{
                      amount=int.parse(val);
                    }
                    catch(e) {}
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Static.PrimaryColor,
                  borderRadius: BorderRadius.circular(16.0,
                  ),
                ),
                padding: EdgeInsets.all(
                  12.0,
                ),

                child: Icon(
                  Icons.description,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),

              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Note on Transaction",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val) {
                    note=val;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Static.PrimaryColor,
                  borderRadius: BorderRadius.circular(16.0,
                  ),
                ),
                padding: EdgeInsets.all(
                  12.0,
                ),

                child: Icon(
                  Icons.money_sharp,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),

              ChoiceChip(
                label: Text("Income",
                style: TextStyle(
                  fontSize: 16.0,
                  color: type=="Income"?Colors.white:Colors.black,
                ),),
                selectedColor: Static.PrimaryColor,
                selected: type == "Income" ? true : false,
                onSelected: (val){
                  if(val){
                    setState(() {
                      type = "Income";
                    });
                  }
                },
              ),

              SizedBox(
                width: 12.0,
              ),

              ChoiceChip(
                label: Text("Expense",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: type=="Expense"?Colors.white:Colors.black,
                  ),),
                selectedColor: Static.PrimaryColor,
                selected: type == "Expense" ? true : false,
                onSelected: (val){
                  if(val){
                    setState(() {
                      type = "Expense";
                    });
                  }
                },
              ),
            ],
          ),

          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: TextButton(
                onPressed: (){
                  _selectDate(context);
                },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.zero,
                ),
              ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Static.PrimaryColor,
                        borderRadius: BorderRadius.circular(16.0,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        12.0,
                      ),

                      child: Icon(
                        Icons.date_range,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(
                      width: 12.0,
                    ),

                    Text(
                      "${selectedDate.day} ${months[selectedDate.month-1]}",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
                onPressed: () async {
                  if (amount != null && note.isNotEmpty) {
                    DbHelper dbHelper = DbHelper();
                    await dbHelper.addData(amount!, selectedDate, type, note);
                    Navigator.of(context).pop();
                  }else{
                    print("Not all values provided.");
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ),
          ),
        ],
      )
    );
  }
}
