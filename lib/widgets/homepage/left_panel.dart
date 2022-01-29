import 'package:flutter/material.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({Key? key}) : super(key: key);

  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  int _selectedDestination = 0;

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Drawer(
              elevation: 0.0,
              child: ListView(
                // Important: Remove any padding from the ListView.

                shrinkWrap: true,
                // padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Header',
                      style: textTheme.headline6,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Item 1'),
                    selected: _selectedDestination == 0,
                    onTap: () => selectDestination(0),
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Item 2'),
                    selected: _selectedDestination == 1,
                    onTap: () => selectDestination(1),
                  ),
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text('Item 3'),
                    selected: _selectedDestination == 2,
                    onTap: () => selectDestination(2),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Label',
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Item A'),
                    selected: _selectedDestination == 3,
                    onTap: () => selectDestination(3),
                  ),
                ],
              ),
            ),
          ),
          // VerticalDivider(
          //   width: 1,
          //   thickness: 1,
          // ),
        ],
      ),
    );
  }
}
