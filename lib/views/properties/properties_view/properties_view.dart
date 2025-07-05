import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/models/args_models/property_edit_args.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/views/properties/properties_view/properties_view_cubit.dart';

class PropertiesView extends StatefulWidget {
  final int collectionId;
  const PropertiesView({required this.collectionId, super.key});

  @override
  _PropertiesViewState createState() => _PropertiesViewState();
}

class _PropertiesViewState extends State<PropertiesView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertiesViewCubit, PropertiesViewState>(
      listener: (context, state){},
      child: BlocBuilder<PropertiesViewCubit, PropertiesViewState>(
        builder: (context, state){
          List<CollectionProperty>? properties = state.properties;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Properties'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, editPropertiesRoute, arguments: PropertyEditArgs(collectionId: widget.collectionId, property: null));
              },
              tooltip: 'Add new property',
              backgroundColor: ColorsPalette.boyzone,
              child: Icon(Icons.add, color: ColorsPalette.white),
            ),
            body: properties != null ? Container(
              padding: EdgeInsets.symmetric(horizontal: borderPadding),
              child: properties.isNotEmpty ? SingleChildScrollView(child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: properties.length,
                itemBuilder: (context, position){
                  final CollectionProperty property = properties[position];
                  return Card(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, editPropertiesRoute, arguments: PropertyEditArgs(collectionId: widget.collectionId, property: property));
                      },
                      child: ListTile(
                        title: Text(property.name!, style: appTextStyle(fontSize: accentFontSize)),
                        subtitle: RichText(
                          text: TextSpan(
                            text: property.type,
                            style: appTextStyle(color: ColorsPalette.black),
                            children: <TextSpan>[
                              property.isDropdown! ? TextSpan(text: ', dropdown') : TextSpan(),
                              property.comment != null ? TextSpan(text: ', ${property.comment}'): TextSpan(),
                            ]
                          )
                        )
                      ),
                    ),
                  );
                },
              )) : Center(child: Text('No properties')),
            ) : loadingWidget(ColorsPalette.algalFuel)
          );
        }
      )
    );
  }
}
