import 'package:denning_portal/screens/student_screens/events/event_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../custom_widgets/custom_textStyle.dart';
import '../../../custom_widgets/no_internet_screen.dart';
import '../../../providers/internet_checker.dart';
import '../../../utils/colors.dart';
import '../../../providers/theme.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String? token = "";
  String? studentId = "";
  String? search;
  TextEditingController searchController = TextEditingController();

  DashboardController dashboardController = DashboardController();

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      studentId = prefs.getString('studentId');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    var size = MediaQuery.of(context).size;
    final _width = MediaQuery.of(context).size.width;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    final theme = Provider.of<ThemeChanger>(context);
    final isOnline = Provider.of<ConnectivityService>(context).isOnline;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: CustomTextStyle.AppBarHeading(
              context, theme.isDark ? white : black),
        ),
        elevation: 0,
        backgroundColor: theme.isDark ? cardColor : whiteBottomBar,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        iconTheme: IconThemeData(color: theme.isDark ? white : black),
      ),
      body: isOnline! ? Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Theme(
              child: TextFormField(
                controller: searchController,
                onChanged: (String value) {
                  setState(() {
                    search = value;
                  });
                },
                cursorColor: theme.isDark ? white : black,
                style: TextStyle(color: theme.isDark ? white : black),
                decoration: InputDecoration(
                  labelText: "Search Events",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.isDark ? white : black,
                  ),
                  fillColor: theme.isDark ? white : black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.isDark ? white : black, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide:
                        new BorderSide(color: theme.isDark ? white : black),
                  ),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: CustomTextStyle.bodyRegular(
                      context, theme.isDark ? white : black),
                  labelStyle: CustomTextStyle.bodyRegular(
                      context, theme.isDark ? white : black),
                ),
              ),
              data: Theme.of(context).copyWith(
                primaryColor: theme.isDark ? white : black,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            FutureBuilder(
              future: dashboardController.dashboardData(token, studentId),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: theme.isDark ? white : cardColor,
                  ));
                } else {
                  return snapshot.data['events'] == null
                      ? Text("No data available")
                      : Expanded(
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: (itemWidth / itemHeight),
                                    ),
                              controller:  ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!['events'].length,
                              itemBuilder: (context, int index) {
                                final _height =
                                    MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).padding.top -
                                        kToolbarHeight;
                                final _width =
                                    MediaQuery.of(context).size.width;
                                if (searchController.text.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 12,),
                                      //Text("23 Days Left",style: TextStyle(fontFamily: "Montserrat-Regular",fontSize: _width * 0.035,color: black),),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetails(snapshot
                                                              .data!['events']
                                                          [index])));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0 , left: 8.0 , bottom: 0.0, top: 0),
                                            child: Container(
                                              width: double.infinity,
                                              height: _height*0.42,
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: snapshot.data![
                                                                      'events']
                                                                  [index]
                                                              ['image'] !=
                                                          null
                                                      ? NetworkImage(
                                                          "${snapshot.data!['events'][index]['image']}")
                                                      : AssetImage(
                                                              "assets/images/default_event_image.jpg")
                                                          as ImageProvider,
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.4),
                                                      BlendMode.dstATop),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: _width * 0.03,
                                                    right: _width * 0.03,
                                                    top: _width * 0.03,
                                                    bottom: _width * 0.03),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              DateFormat(
                                                                      'MMMM dd')
                                                                  .format(
                                                                DateTime.parse(
                                                                  snapshot.data![
                                                                              'events']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'notice_date'],
                                                                ),
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              // snapshot.data[index].start_date,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Poppins-Bold",
                                                                  fontSize:
                                                                      _width *
                                                                          0.01,
                                                                  color: white),
                                                            ),
                                                            Text(
                                                              DateFormat('yyyy')
                                                                  .format(
                                                                DateTime.parse(snapshot
                                                                            .data![
                                                                        'events'][index]
                                                                    [
                                                                    'notice_date']),
                                                              ),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Poppins-SemiBold",
                                                                  fontSize:
                                                                      _width *
                                                                          0.02,
                                                                  color: white),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                        //   Spacer(),
                                                        // //   Icon(
                                                        // //     Icons.share,
                                                        // //     color: white,
                                                        // //     size: _width * 0.05,
                                                        // //   )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${snapshot.data!['events'][index]['notice_title']}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Poppins-Bold",
                                                          fontSize:
                                                              _width * 0.02,
                                                          color: white),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: white,
                                                          size: _width * 0.02,
                                                        ),
                                                        Container(
                                                          width: _width * 0.1,
                                                          child: Text(
                                                            "${snapshot.data!['events'][index]['venue']}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins-Regular",
                                                                fontSize:
                                                                    _width *
                                                                        0.01,
                                                                color: white),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "${snapshot.data!['events'][index]['notice_time']}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins-Regular",
                                                              fontSize:
                                                                  _width * 0.01,
                                                              color: white),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.data!['events'][index]
                                            ['notice_title']
                                        .toLowerCase()
                                        .contains(searchController.text) ||
                                    snapshot.data!['events'][index]
                                            ['notice_title']
                                        .toUpperCase()
                                        .contains(searchController.text)) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: _height * 0.02,
                                      ),
                                      //Text("23 Days Left",style: TextStyle(fontFamily: "Montserrat-Regular",fontSize: _width * 0.035,color: black),),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetails(snapshot
                                                          .data!['events']
                                                      [index])));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(40.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0 , left: 8.0 , bottom: 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: _height*0.42,
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: snapshot.data![
                                                  'events']
                                                  [index]
                                                  ['image'] !=
                                                      null
                                                      ? NetworkImage(
                                                      "${snapshot.data!['events'][index]['image']}")
                                                      : AssetImage(
                                                      "assets/images/default_event_image.jpg")
                                                  as ImageProvider,
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.4),
                                                      BlendMode.dstATop),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: _width * 0.03,
                                                    right: _width * 0.03,
                                                    top: _width * 0.03,
                                                    bottom: _width * 0.03),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              DateFormat(
                                                                  'MMMM dd')
                                                                  .format(
                                                                DateTime.parse(
                                                                  snapshot.data![
                                                                  'events']
                                                                  [
                                                                  index]
                                                                  [
                                                                  'notice_date'],
                                                                ),
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              // snapshot.data[index].start_date,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  "Poppins-Bold",
                                                                  fontSize:
                                                                  _width *
                                                                      0.01,
                                                                  color: white),
                                                            ),
                                                            Text(
                                                              DateFormat('yyyy')
                                                                  .format(
                                                                DateTime.parse(snapshot
                                                                    .data![
                                                                'events'][index]
                                                                [
                                                                'notice_date']),
                                                              ),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  "Poppins-SemiBold",
                                                                  fontSize:
                                                                  _width *
                                                                      0.02,
                                                                  color: white),
                                                              maxLines: 2,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                        //   Spacer(),
                                                        // //   Icon(
                                                        // //     Icons.share,
                                                        // //     color: white,
                                                        // //     size: _width * 0.05,
                                                        // //   )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${snapshot.data!['events'][index]['notice_title']}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          "Poppins-Bold",
                                                          fontSize:
                                                          _width * 0.02,
                                                          color: white),
                                                      maxLines: 2,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: white,
                                                          size: _width * 0.02,
                                                        ),
                                                        Container(
                                                          width: _width * 0.1,
                                                          child: Text(
                                                            "${snapshot.data!['events'][index]['venue']}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                "Poppins-Regular",
                                                                fontSize:
                                                                _width *
                                                                    0.01,
                                                                color: white),
                                                            maxLines: 2,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "${snapshot.data!['events'][index]['notice_time']}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "Poppins-Regular",
                                                              fontSize:
                                                              _width * 0.01,
                                                              color: white),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return SizedBox(
                                  height: 0,
                                );
                              }),
                        );
                }
              },
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ): NoInternetScreen() ,
    );
  }
}
