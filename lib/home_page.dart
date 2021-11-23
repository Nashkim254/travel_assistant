import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jua_area/details.dart';
import 'package:jua_area/filter.dart';
import 'package:jua_area/ui/auth/service/auth_service.dart';
import 'package:location/location.dart' as locationManager;

const kGoogleApiKey = "AIzaSyBfE8-06S2c5_u-mZaX7_cKP6F7_ErvVgQ";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
SizedBox zeroHeightSizedBox = SizedBox(height: 0);
String autID = FirebaseAuth.instance.currentUser.uid;
final AuthService _auth = AuthService();
  int _currentIndex = 0;

  int _selected = 0;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  final Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    Widget expandedChild;
    if (isLoading) {
      expandedChild = Center(child: CircularProgressIndicator(value: null));
    } else if (errorMessage != null) {
      expandedChild = Center(
        child: Text(errorMessage),
      );
    } else {
      expandedChild = buildPlacesList();
    }

    return Scaffold(
        key: homeScaffoldKey,
        bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          height: 60,
          color: Colors.white54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.lightBlueAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.search,color: Colors.grey,),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                      _handlePressButton();
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.navigation,color: Colors.grey,),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>Filter()));
                    });
                  }),
              
            ],
          ),
        ),
      ),
        appBar: AppBar(
          title: const Text("Jua Area"),
          actions: <Widget>[
            isLoading
                ? IconButton(
                    icon: Icon(Icons.timer),
                    onPressed: () {},
                  )
                : IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      refresh();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      _auth.signOut();
                    },
                  ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: SizedBox(
                  height: 200.0,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(0.0, 0.0)),
                    markers: _markers,
                  )),
            ),
            Expanded(child: expandedChild)
          ],
        ));
  }

  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    getNearbyPlaces(center);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  Future<LatLng> getUserLocation() async {
    //var currentLocation = <String, double>{};
    final location = locationManager.Location();
    try {
      var currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      return null;
    }
  }

  void getNearbyPlaces(LatLng center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(lat: center.latitude, lng: center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);

    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
        result.results.forEach((f) {
          final markerOptions = Marker(
              position:
                  LatLng(f.geometry.location.lat, f.geometry.location.lng),
              infoWindow:
                  InfoWindow(title: "${f.name}", snippet: "${f.types?.first}"),
              markerId: MarkerId(center.toString()));
          _markers.add(markerOptions);
        });
      } else {
        this.errorMessage = result.errorMessage;
      }
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: Mode.fullscreen,
          language: "en",
          location: center == null
              ? null
              : Location(lat: center.latitude, lng: center.longitude),
          radius: center == null ? null : 10000);

      showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async {
    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
      );
    }
  }

  ListView buildPlacesList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        )
      ];
      if (f.formattedAddress != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.formattedAddress,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ));
      }

      if (f.vicinity != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.vicinity,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ));
      }

      if (f.types?.first != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.types.first,
            style: Theme.of(context).textTheme.caption,
          ),
        ));
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: () {
              showDetailPlace(f.placeId);
            },
            highlightColor: Colors.lightBlueAccent,
            splashColor: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList();

    return ListView(shrinkWrap: true, children: placesWidget);
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      String text, String icon) {
    return BottomNavigationBarItem(
      icon: Container(width: 30, height: 30, child: SvgPicture.asset(icon)),
      title: zeroHeightSizedBox,
    );
  }
}
