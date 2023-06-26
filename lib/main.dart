import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import  'dart:math';
import 'package:provider/provider.dart';
import 'theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: CalculatorApp(),
    ),
  );
}

class CalculatorApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HyperCalc',
          theme: theme.themeMode == ThemeMode.light
              ? ThemeData.light().copyWith(
            // Customize the light theme colors
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.deepPurple,
            ),
            drawerTheme: DrawerThemeData(
              backgroundColor: Colors.deepPurple.shade200,
            ),
            listTileTheme: ListTileThemeData(
              iconColor: Colors.deepPurple,
              textColor: Colors.deepPurple,
            ),

            scaffoldBackgroundColor: Colors.deepPurple.shade200,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
            ),
          )
              : ThemeData.dark().copyWith(
            // Customize the dark theme colors
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey,
            ),
            scaffoldBackgroundColor: Colors.blueGrey.shade700,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey.shade200,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.blueGrey.shade200),
              ),
            ),

            drawerTheme: DrawerThemeData(
              backgroundColor: Colors.blueGrey.shade900,
            ),
            listTileTheme: ListTileThemeData(
              iconColor: Colors.blueGrey.shade200,
              textColor: Colors.blueGrey.shade200,
            ),
        ),
          home: SimpleCalculator(),
        );
      },
    );
  }
}

class SimpleCalculator extends StatefulWidget {
   @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {

String equation = "0";
String result = "0";
String expression = "";
double equationFontSize = 48.0;
double resultFontSize = 38.0;
  buttonPressed(String buttonText){
setState(() {

if(buttonText == "C"){
  equation = "0";
  result = "0";
  equationFontSize = 48.0;
  resultFontSize = 38.0;
}
else if(buttonText == "⌫"){
  equationFontSize = 48.0;
  resultFontSize = 38.0;
  equation = equation.substring(0, equation.length-1);
  if(equation == ""){
    equation = "0";
  }

}
else if(buttonText == "="){
  equationFontSize = 48.0;
  resultFontSize = 38.0;

  expression = equation;
  expression = expression.replaceAll('×', '*');
  expression = expression.replaceAll('÷', '/');
  try{
    Parser p = new Parser();
    Expression exp = p.parse(expression);

    ContextModel cm = ContextModel();
    result = '${exp.evaluate(EvaluationType.REAL,cm)}';
    if(buttonText=="Ans"){
      equation = result;
    }

  }catch(e){
    result= "Syntactical error" ;
  }
}
else{
  if(equation == "0"){
    equation=buttonText;
  }
  else {
    equation = equation + buttonText;
  }
}
});
  }
bool isButtonPressed = false;
void handlebuttonpress(){
  setState(() {
    isButtonPressed = !isButtonPressed;
    isButtonPressed ? result : equation;
  });
  }

  Widget buildButton (String buttonText, double buttonHeight/*, Color buttonColor*/){
    return Container(
      height: MediaQuery.of(context).size.height*0.1*buttonHeight,
     /*color: buttonColor,*/
      child: TextButton(

        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
          ),
          padding: EdgeInsets.all(16.0),
        ),
        onPressed:() => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              //color: Colors.white
          ),
        ),
      ),
    );

  }
Widget Answerbutton(){
  return TextButton(
    child: Text('Ans', style: TextStyle(
      fontSize: 32,),
    ),
    onPressed: () {
      equation = result;
      handlebuttonpress();
    },
  );
}
  Widget displayequation(String textvalue){
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(10,20,10,0),
      child: Text(textvalue,style: TextStyle(fontSize: equationFontSize),),
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Scaffold(

      appBar: AppBar(

        title: Text('Hyper calculator'),
      centerTitle: true,
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              //child: SizedBox(height: 40.0,),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bodmath.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                color: Colors.blueGrey,
              ),
              child: Text(''),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on,
                size: 25,
              ),
              title: Text('Donate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context)=> DetailScreen(
                        widgetFunction: donation
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.0,),
           /* ListTile(
              leading: FaIcon(FontAwesomeIcons.twitter,
                color: Colors.blueGrey,
                size: 25,),
              title: Text('Follow us',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
               // _launchTwitterURL();
              },
            ),*/
            SizedBox(height: 20.0,),
            ListTile(
              leading: Icon(Icons.share,
                size: 25,
              ),
              title: Text('Share',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
              },
            ),
            SizedBox(height: 20.0,),
            ListTile(
              leading: Icon(Icons.light_mode,
                size: 25,
              ),
              title: Text('Light mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
              onTap: (){
                theme.themeMode = ThemeMode.light;
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode,
                size: 25,
              ),
              title: Text('dark mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
              onTap: (){
                theme.themeMode = ThemeMode.dark;
              },
            ),
            SizedBox(height: 20.0,),
            ListTile(
              leading: Icon(Icons.info,
                size: 25,
              ),
              title: Text('About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context)=> DetailScreen(
                        widgetFunction: about
                    ),
                  ),
                );


              },
            ),

            SizedBox(height: 180,),

          ],
        ),
      ),
      body: Column(
        children: <Widget>[

           displayequation(equation),

          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10,20,10,0),
            child: Text(result,style: TextStyle(fontSize: resultFontSize),),
          ),

          Expanded(
            child: Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(

              child: Table(
                children: [
                  TableRow(
                    children: [
                      buildButton("C",1/*,Colors.deepOrangeAccent*/),
                      buildButton("⌫",1/*,Colors.deepOrangeAccent*/),
                      buildButton("÷",1/*,Colors.blueGrey*/),
                      ]
                  ),
                  TableRow(
                      children: [
                        buildButton("7",1/*,Colors.black54*/),
                        buildButton("8",1/*,Colors.black54*/),
                        buildButton("9",1/*,Colors.black54*/),
                      ]
                  ),
                  TableRow(
                      children: [
                        buildButton("4",1/*,Colors.black54*/),
                        buildButton("5",1/*,Colors.black54*/),
                        buildButton("6",1/*,Colors.black54*/),
                      ]
                  ),
                  TableRow(
                      children: [
                        buildButton("1",1/*,Colors.black54*/),
                        buildButton("2",1/*,Colors.black54*/),
                        buildButton("3",1/*,Colors.black54*/),
                      ]
                  ),
                  TableRow(
                      children: [
                        buildButton(".",1/*,Colors.black54*/),
                        buildButton("0",1/*,Colors.black54*/),
                        buildButton("00",1/*,Colors.black54*/),
                      ]
                  )
                ],
              ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.25,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton("×",1/*,Colors.blueGrey*/),
                      ]
                    ),
                    TableRow(
                        children: [
                          buildButton("-",1/*,Colors.blueGrey*/),
                        ]
                    ),
                    TableRow(
                        children: [
                          buildButton("+",1/*,Colors.blueGrey*/),
                        ]
                    ),
                    TableRow(
                        children: [
                          buildButton("=",1/*,Colors.deepOrangeAccent*/),
                        ]
                    ),

                    TableRow(

                        children: [
                          Answerbutton(),
                         // buildButton("Ans",1/*,Colors.deepOrangeAccent*/),
                        ]
                    ),

                  ],
                ),
              )
            ],
          ),

              ],
      )


    );
  }
}
Widget donation() {
  return Container(
      margin: EdgeInsets.only(top: 12, left: 10, right: 10),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 1, left: 16, right: 16),
              child: Text(
                ' Your contributions play a crucial'
                    ' role in sustaining and improving the app, making it even better for everyone.'
                    ' Thank you for your kind and generous'
                    ' support.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),
          ListTile(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              // contentPadding: EdgeInsets.symmetric(horizontal:10,vertical:5,),
              tileColor: Colors.white,
              leading: FaIcon(FontAwesomeIcons.medal,
                color: Color(0xFFCD7F32),
                size: 24,
              ),
              title:Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bronze package',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                  Text('Ksh 100.00',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  )
                ],
              )

          ),
          SizedBox(height: 20,),
          ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal:20,vertical:5,),
              tileColor: Colors.white,
              leading: FaIcon(FontAwesomeIcons.medal,
                color: Color(0xFF808080),
                size: 24,
              ),
              title:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Silver package',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Ksh300.00',
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  )
                ],
              )
          ),
          SizedBox(height: 20,),
          ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal:20,vertical:5,),
              tileColor: Colors.white,
              leading: FaIcon(FontAwesomeIcons.medal,
                color: Colors.yellow[800],
                size: 24,
              ),
              title:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gold package',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text('Ksh500.00',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ]
              )
          ),
          SizedBox(height: 20,),


          SizedBox(height: 140,),
        ],
      )
  );
}
Widget about(){
  return Container(
    alignment: Alignment.topCenter,
    padding: EdgeInsets.fromLTRB(15,20,10,0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hypercalc ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Version: 1.0.0',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),


        SizedBox(height: 16),
        Text(
          'Developer Information:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Juma Emmanuel',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),

          Text(
                'jumaemmanuel.netlify.app',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),

        SizedBox(height: 16),

            SizedBox(height: 8),

        Text(
          'Privacy policy:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'This application does not collect any personal information',

          style: TextStyle(fontSize: 16),
        ),

        SizedBox(height: 16),

          ],
    ),
  );
}
class DetailScreen extends StatelessWidget {
  // const DetailScreen({Key? key}) : super(key: key);

  final Widget Function()  widgetFunction;
  // final Widget Function()  copyrightFunction;

  DetailScreen({required this.widgetFunction});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
       // backgroundColor: Colors.pink[100],
      ),

      body: Column(
        children: [
          widgetFunction!(),

        ],
      ),

    );
  }
}








