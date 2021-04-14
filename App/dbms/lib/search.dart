import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms/widgets/showDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search extends StatefulWidget {
  static const historyLength = 5;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // List<String> searchHistory = [];

  List<String> filteredSearchHistory;

  getdetails ob = getdetails();
  String selectedTerm;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      return ob.nouns.reversed
          .where((term) => term.toLowerCase().startsWith(filter.toLowerCase()))
          .toList();
    } else {
      return ob.nouns.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (ob.nouns.contains(term)) {
      // This method will be implemented soon
      // putSearchTermFirst(term);
      return;
    }
    if (ob.nouns.length > Search.historyLength) {
      ob.nouns.removeRange(0, ob.nouns.length - Search.historyLength);
    }
    // Changes in searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    ob.nouns.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    call();
    print(ob.nouns);
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  Future<void> call() async {
    await ob.getMarker();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: controller,
      body: FloatingSearchBarScrollNotifier(
        child: SearchResultsListView(
          searchTerm: selectedTerm,
        ),
      ),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      title: Text(
        selectedTerm ?? 'Search Here',
        style: Theme.of(context).textTheme.headline6,
      ),
      hint: 'Search and find',
      actions: [
        FloatingSearchBarAction.searchToClear(),
      ],
      onQueryChanged: (query) {
        setState(() {
          filteredSearchHistory = filterSearchTerms(filter: query);
        });
      },
      onSubmitted: (query) {
        setState(() {
          addSearchTerm(query);
          selectedTerm = query;
        });
        controller.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: Builder(
              builder: (context) {
                if (filteredSearchHistory.isEmpty && controller.query.isEmpty) {
                  return Container(
                    height: 56,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Start Searching',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                } else if (filteredSearchHistory.isEmpty) {
                  return ListTile(
                    title: Text(controller.query),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      setState(() {
                        addSearchTerm(controller.query);
                        selectedTerm = controller.query;
                      });
                      controller.close();
                    },
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filteredSearchHistory
                        .map(
                          (term) => ListTile(
                            title: Text(
                              term,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: const Icon(Icons.home_work_outlined),
                            onTap: () {
                              setState(() {
                                putSearchTermFirst(term);
                                selectedTerm = term;
                              });
                              controller.close();
                              _SearchResultsListViewState().build(context);
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class SearchResultsListView extends StatefulWidget {
  String searchTerm;
  SearchResultsListView({String searchTerm}) {
    this.searchTerm = searchTerm;
  }

  @override
  _SearchResultsListViewState createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  // ignore: non_constant_identifier_names
  List<String> doctors_name = [];
  calling() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Details')
        .doc(widget.searchTerm)
        .collection('Name')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) {
      setState(() {
        doctors_name.add(data.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(doctors_name);
    if (widget.searchTerm == null) {
      return Center(
        child: Container(
          color: Colors.white,
          child: Text(
            'Search Hospital and Get Details 😊',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name: ${widget.searchTerm}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            doctors_name.clear();
                          });
                          calling();
                        },
                        child: Text("Search")),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...doctors_name.map((e) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(bottom: 12),
                        width: double.infinity,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(height: 70),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              elevation: 12,
                              padding: EdgeInsets.only(left: 3),
                              shadowColor: Colors.tealAccent,
                            ),
                            child: Text(
                              'Dr.$e',
                            ),
                            onPressed: () {
                              Get.to(ShowDetails(e, widget.searchTerm));
                            },
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

// ignore: camel_case_types
class getdetails {
  List<String> nouns = [];
  getMarker() async {
    // _SearchState sc = _SearchState();
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Details').get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) => nouns.add(data.id));
  }
}
