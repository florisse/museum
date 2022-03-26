import 'package:flutter/material.dart';
import 'package:gestion_musee/Screens/liste_bibliotheques.dart';
import 'package:gestion_musee/Screens/liste_musees.dart';
import 'package:gestion_musee/Screens/liste_pays.dart';
import 'package:gestion_musee/Screens/liste_visites.dart';
import 'package:gestion_musee/main.dart';

import '../Database/DatabaseProvider.dart';
import 'liste_ouvrages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var currentPage = DrawerSections.sectionMusees;

  @override
  void initState() {
    super.initState();
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.sectionPays) {
      container = const ListePays();
    } else if (currentPage == DrawerSections.sectionMusees) {
      container = const ListeMusees();
    } else if (currentPage == DrawerSections.sectionOuvrages) {
      container = const ListeOuvrages();
    } else if (currentPage == DrawerSections.sectionBibliotheques) {
      container = const ListeBibliotheques();
    } else if (currentPage == DrawerSections.sectionVisites) {
      container = const ListeVisites();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Smart Museum App'),
          backgroundColor: myColor,
          leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: const Icon(
                      Icons.menu,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    }),
          ),
        ),
        drawer: Drawer(
          child: Container(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      MyDrawerList(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        children: const [
                          Divider(),
                          Text('Smart Museum App 1.0.0')
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        body: container,
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Les Musées",
              currentPage == DrawerSections.sectionMusees ? true : false),
          Divider(),
          menuItem(2, "Les Pays",
              currentPage == DrawerSections.sectionPays ? true : false),
          Divider(),
          menuItem(3, "Les Ouvrages",
              currentPage == DrawerSections.sectionOuvrages ? true : false),
          Divider(),
          menuItem(
              4,
              "Les Bibliothèques",
              currentPage == DrawerSections.sectionBibliotheques
                  ? true
                  : false),
          Divider(),
          menuItem(5, "Les Visites",
              currentPage == DrawerSections.sectionVisites ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, bool selected) {
    return Material(
      child: InkWell(
        onTap: () {
          toggleDrawer();
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.sectionMusees;
            } else if (id == 2) {
              currentPage = DrawerSections.sectionPays;
            } else if (id == 3) {
              currentPage = DrawerSections.sectionOuvrages;
            } else if (id == 4) {
              currentPage = DrawerSections.sectionBibliotheques;
            } else if (id == 5) {
              currentPage = DrawerSections.sectionVisites;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  sectionPays,
  sectionBibliotheques,
  sectionOuvrages,
  sectionMusees,
  sectionVisites,
}
