import 'package:flutter/material.dart';
import 'newPage.dart';

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({super.key});

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  final List<Map<String, String>> data = [
    {
      "Title": "Item 1",
      "SubTitle": "7",
      "Image": "https://picsum.photos/250?image=9",
    },
    {
      "Title": "Item 2",
      "SubTitle": "10",
      "Image": "https://picsum.photos/250?image=9",
    },
    {
      "Title": "Item 3",
      "SubTitle": "3",
      "Image": "https://picsum.photos/250?image=9",
    },
    {
      "Title": "Item 4",
      "SubTitle": "55",
      "Image": "https://picsum.photos/250?image=9",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Demo'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                width: 400,
                height: 80,
                child: Card(
                  color: Colors.brown,
                  child: ListTile(
                    title: Text(
                      data[index]["Title"]!,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      data[index]["SubTitle"]!,
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Image.network(data[index]["Image"]!, width: 40),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPage(
                            title: data[index]["Title"]!,
                            subtitle: data[index]["SubTitle"]!,
                            image: data[index]["Image"]!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
