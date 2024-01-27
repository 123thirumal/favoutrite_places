import 'package:fav_places_app/provider/placelist_provider.dart';
import 'package:fav_places_app/screen/place_screen.dart';
import 'package:fav_places_app/widget/add_new_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/place_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  late Future<void> _placesList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _placesList=ref.watch(FavPlaceProvider.notifier).loadData();
  }


  @override
  void initState(){
    super.initState();
  }

  void _showDialogBox(Place item){
    bool _isDeleting=false;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: ThemeData().colorScheme.secondary,
            title: const Text('Delete the Place'),
            actions: [
              ElevatedButton(
                onPressed: Navigator.of(ctx).pop,
                child: const Text('cancel'),
              ),
              ElevatedButton(
                  onPressed:() async {
                    setState(() {
                      _isDeleting=true;
                    });
                    await ref.watch(FavPlaceProvider.notifier).deletePlace(item);
                    await ref.watch(FavPlaceProvider.notifier).loadData();
                    setState(() {
                      _isDeleting=false;
                    });
                    if(!context.mounted){
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: _isDeleting ? const Center(child: CircularProgressIndicator(),) : const Text('OK')
              ),
            ],
          );
        });
  }

  void openBottomsheet(){
    showModalBottomSheet(
        useSafeArea:true,
        isScrollControlled: true,
        context: context,
        builder: (ctx){
          return const AddPlace();
        });
  }
  @override
  Widget build(context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Places'),
      ),
      body: FutureBuilder(
        future: _placesList,
        builder: (context,snapshot){
          return snapshot.connectionState==ConnectionState.waiting
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : (ref.watch(FavPlaceProvider).isEmpty)
              ? const Center(
            child: Text('Press + to add favourite places',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
          )
              : ListView.builder(
            itemCount: ref.watch(FavPlaceProvider).length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder:(ctx){
                    return PlaceScreen(placeItem: ref.watch(FavPlaceProvider)[index]);
                  }));
                },
                onLongPress: (){
                  _showDialogBox(ref.watch(FavPlaceProvider)[index]);
                },
                child: Card(
                  color: ThemeData().colorScheme.secondary,
                  child:Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          foregroundImage: FileImage(ref.watch(FavPlaceProvider)[index].placeImage),
                        ),
                        const SizedBox(width: 20,),
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 265,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ref.watch(FavPlaceProvider)[index].name,style:const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),),
                              const SizedBox(height: 5,),
                              Text(ref.watch(FavPlaceProvider)[index].address,style:const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openBottomsheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
