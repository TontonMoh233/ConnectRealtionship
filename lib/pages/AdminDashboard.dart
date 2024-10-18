import 'package:flutter/material.dart';

import 'Overveiw.dart';
import 'PartProjet.dart';
import 'UsernameDasboard.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord Administrateur'),
      ),
      drawer: AdminDrawer(),
      body: DashboardOverview(),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Vue d\'ensemble'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Utilisateurs'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UserManagementPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Projets'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AdminProjectsDashboard()),
              );
            },

          ),
          ListTile(
            leading: Icon(Icons.request_page),
            title: Text('Demandes de Contact'),
        //    onTap: () {
          //    Navigator.of(context).push(
          //      MaterialPageRoute(builder: (context) => ContactRequestPage()),
            //  );
           // },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Financements'),
            onTap: () {
            //  Navigator.of(context).push(
            //    MaterialPageRoute(builder: (context) => FundingPage()),
            //  );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Administration'),
            onTap: () {
             // Navigator.of(context).push(
            //    MaterialPageRoute(builder: (context) => AdminSettingsPage()),
             // );
            },
          ),
        ],
      ),
    );
  }
}
