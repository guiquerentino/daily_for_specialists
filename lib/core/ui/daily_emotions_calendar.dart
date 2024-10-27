import 'package:daily_for_specialists/domain/models/patient_dto.dart';
import 'package:daily_for_specialists/utils/environment_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DailyEmotionsCalendar extends StatefulWidget {
  final PatientDto patient;
  const DailyEmotionsCalendar({super.key, required this.patient});

  @override
  State<DailyEmotionsCalendar> createState() => _DailyEmotionsCalendarState();
}

class _DailyEmotionsCalendarState extends State<DailyEmotionsCalendar> {
  final ScrollController _scrollController = ScrollController();
  late DateTime dataSelecionada;
  DateTime dataAtual = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    dataSelecionada = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    int diaAtual = dataSelecionada.day;
    double offset = (diaAtual - 1) * 58.0;
    _scrollController.jumpTo(offset);
  }

  void _incrementMonth() {
    setState(() {
      dataAtual = DateTime(dataAtual.year, dataAtual.month + 1, 1);
    });
  }

  void _decrementMonth() {
    setState(() {
      dataAtual = DateTime(dataAtual.year, dataAtual.month - 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    String mesAnoAtual = toBeginningOfSentenceCase(
        DateFormat.yMMMM('pt_BR').format(dataAtual)) ??
        '';
    int ultimoDiaDoMes =
    DateUtils.getDaysInMonth(dataAtual.year, dataAtual.month);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: _decrementMonth,
                icon: Icon(Icons.arrow_back_ios_new, size: 18)),
            Text(mesAnoAtual,
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Pangram',
                    fontWeight: FontWeight.bold)),
            IconButton(
                onPressed: _incrementMonth,
                icon: Icon(Icons.arrow_forward_ios, size: 18)),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          height: 80,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 1; i <= ultimoDiaDoMes; i++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 9.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          dataSelecionada = DateTime(dataAtual.year, dataAtual.month, i);
                          EnvironmentUtils.dataAtual = dataSelecionada;
                        });
                      },
                      child: Container(
                        height: 68,
                        width: 50,
                        decoration: BoxDecoration(
                          color: (dataSelecionada.day == i &&
                              dataSelecionada.month == dataAtual.month)
                              ? const Color.fromRGBO(158, 181, 103, 1)
                              : Colors.white,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(25)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 4.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                DataUtils.formatDate(DateFormat()
                                    .add_EEEE()
                                    .format(DateTime(
                                    dataAtual.year, dataAtual.month, i))),
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontFamily: 'Pangram',
                                    color: (dataSelecionada.day == i &&
                                        dataSelecionada.month ==
                                            dataAtual.month)
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w400)),
                            Text(
                                DateFormat().add_d().format(DateTime(
                                    dataAtual.year, dataAtual.month, i)),
                                style: TextStyle(
                                    color: (dataSelecionada.day == i &&
                                        dataSelecionada.month ==
                                            dataAtual.month)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Pangram',
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DateUtils {
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static String formatDate(String date) {
    return date.split('-').first;
  }
}


class DataUtils {

  static String formatDate(String date){

    if(date == "Monday"){
      return "Seg";
    }

    if(date == "Tuesday"){
      return "Ter";
    }

    if(date == "Wednesday"){
      return "Qua";
    }

    if(date == "Thursday"){
      return "Qui";
    }

    if(date == "Friday"){
      return "Sex";
    }

    if(date == "Saturday"){
      return "Sáb";
    }

    if(date == "Sunday"){
      return "Dom";
    }

    return "aa";

  }

}