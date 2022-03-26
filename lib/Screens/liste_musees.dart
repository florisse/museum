import 'package:flutter/material.dart';
import 'package:gestion_musee/Bloc/MuseeBloc.dart';
import 'package:gestion_musee/Bloc/PaysBloc.dart';
import 'package:gestion_musee/Models/Musee.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Models/Pays.dart';
import '../main.dart';

class ListeMusees extends StatefulWidget {
  const ListeMusees({Key? key}) : super(key: key);

  @override
  State<ListeMusees> createState() => _ListeMuseesState();
}

class _ListeMuseesState extends State<ListeMusees>
    implements AlertDialogCallback {
  TextEditingController txtNomMus = TextEditingController();
  TextEditingController txtNblivres = TextEditingController();
  bool validate_nom = true;
  bool validate_nblivres = true;
  String saveOrUpdateText = '';
  String messageErreur = "";
  bool erreurTextVisible = false;
  String codePays = '';
  final MuseeBloc museeBloc = MuseeBloc();
  final PaysBloc paysBloc = PaysBloc();
  List<Pays> listPays = [];
  late Musee selectedMusee;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getMuseeWidget(AsyncSnapshot<List<Musee>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                return Container(
                  child: Card(
                      elevation: 2.0,
                      child: ListTile(
                          title: Text(snapshot.data![index].nomMus,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              snapshot.data![index].nblivres.toString() +
                                  ' livres',
                              style: const TextStyle(fontSize: 14.0)),
                          leading: const CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://picsum.photos/200/300'),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedMusee = snapshot.data![index];
                                    txtNomMus.text =
                                        snapshot.data![index].nomMus;
                                    txtNblivres.text = snapshot
                                        .data![index].nblivres
                                        .toString();
                                    codePays = snapshot.data![index].codePays
                                        .toString();
                                    saveOrUpdateText = 'Mise à jour';
                                  });
                                  _showDialog();
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedMusee = snapshot.data![index];
                                  });
                                  _showDialogConfirmation();
                                },
                              ),
                            ],
                          ))),
                );
              },
            )
          : Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("Aucun musée enregistré",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 35,
              width: double.infinity,
              color: const Color(0xFFE6E6E6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Liste des musées',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: museeBloc.musees,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Musee>> snapshot) {
                return getMuseeWidget(snapshot);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColor,
        onPressed: () {
          setState(() {
            txtNomMus.text = "";
            txtNblivres.text = "";
            saveOrUpdateText = 'Enregistrer';
          });
          _showDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                  title: const Text("Modifier Musée"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: erreurTextVisible,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 40, left: 20, right: 20),
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                      child: Text(
                                    messageErreur,
                                    style: const TextStyle(
                                      color: Color(0xFFFF0000),
                                      shadows: [
                                        Shadow(
                                          blurRadius: 1,
                                          color: Colors.black26,
                                          offset: Offset(0.5, 0.5),
                                        ),
                                      ],
                                    ),
                                  )),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFCD7CD),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                              child: Row(
                                children: [
                                  const Text("Pays"),
                                  const Spacer(),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: false,
                                      items: listPays.map((pays) {
                                        return DropdownMenuItem<String>(
                                          value: pays.codePays,
                                          child: SizedBox(
                                            width: 150, //expand here
                                            child: Text(
                                              pays.codePays,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          codePays = newValue.toString();
                                        });
                                        // onPaysChange(newValue.toString());
                                      },
                                      hint: const SizedBox(
                                        width: 150, //and here
                                        child: Text(
                                          "Code du pays",
                                          style: TextStyle(color: Colors.grey),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: myColor,
                                          decorationColor: Colors.red),
                                      value: codePays,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                              child: TextFormField(
                                controller: txtNomMus,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  hintText: 'Nom du musée',
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFFDA384)),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: myColor),
                                  ),
                                  errorText: validate_nom == false
                                      ? 'Le champs est obligatoire '
                                      : null,
                                ),
                                cursorColor: myColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                              child: TextFormField(
                                controller: txtNblivres,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  hintText: "Nombre de livres",
                                  errorText: validate_nblivres == false
                                      ? 'Le champs est obligatoire '
                                      : null,
                                  errorStyle:
                                      const TextStyle(color: Color(0xFFFDA384)),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: myColor),
                                  ),
                                ),
                                cursorColor: myColor,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 300,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
                                  save();
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            myColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      //side: BorderSide(color: Colors.red)
                                    ))),
                                //color: const Color(0xFF390047),
                                child: Text(
                                  saveOrUpdateText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            }));
  }

  _showDialogConfirmation() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Confirmation de suppression',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            content: const Text(
              "Voulez-vous vraiment supprimer cet enregistrement?",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Non',
                    style: TextStyle(color: myColor),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ))),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      delete(selectedMusee);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Oui',
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(myColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ))),
                ),
              ),
            ],
          );
        });
  }

  @override
  void save() {
    setState(() {
      txtNomMus.text.trim().isEmpty
          ? validate_nom = false
          : validate_nom = true;
      txtNblivres.text.trim().isEmpty
          ? validate_nblivres = false
          : validate_nblivres = true;
    });
    if (validate_nom && validate_nblivres) {
      Musee musee = Musee(
        numMus: 0,
        nomMus: txtNomMus.text.trim(),
        nblivres: int.parse(txtNblivres.text.trim()),
        codePays: codePays,
      );
      if (saveOrUpdateText == 'Enregistrer') {
        museeBloc.addMusee(musee);
      } else {
        museeBloc.updateMusee(musee);
      }
    }
  }

  @override
  void delete(Musee musee) {
    var data = museeBloc.getMuseeFromOtherTables(musee.numMus).then((value) {
      print('value $value');
      if (value == false) {
        museeBloc.deleteMusee(musee);
      } else {
        Fluttertoast.showToast(
            msg:
                "Désolé, vous ne pouvez pas supprimer ce musée car il est utilisé pour d'autres enregistrement",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 13.0);
      }
    });
  }
}

abstract class AlertDialogCallback {
  void save();
  void delete(Musee musee);
}
