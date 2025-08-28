import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/args_models/property_edit_args.model.dart';
import 'package:rateit/models/property.model.dart';
import 'package:rateit/views/properties/properties_view/cubit/properties_view_cubit.dart';

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
      listener: (context, state){
        if(state is PropertiesViewLoading){
          var duration = Duration(seconds: 3);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
        }
        if(state is PropertiesViewSuccess){
          globalScaffoldMessenger.currentState!
              .hideCurrentSnackBar();
        }
        if(state is PropertiesViewError){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
        }
      },
      child: BlocBuilder<PropertiesViewCubit, PropertiesViewState>(
        builder: (context, state){
          List<Property>? properties = state.properties;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Properties'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
              actions: state.hasEdits ? [
                 IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      context.read<PropertiesViewCubit>().saveOrder();
                    })] : []
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, editPropertiesRoute, arguments: PropertyEditArgs(collectionId: widget.collectionId, property: null)).then((value)
                {
                  if(value != null){
                    if(value is Property){
                      context.read<PropertiesViewCubit>().updatePropertyList(value);
                    }
                  }
                });
              },
              tooltip: 'Add new property',
              backgroundColor: ColorsPalette.boyzone,
              child: Icon(Icons.add, color: ColorsPalette.white),
            ),
            body: properties != null ? Container(
              padding: EdgeInsets.symmetric(horizontal: borderPadding),
              child: properties.isNotEmpty ? SingleChildScrollView(child: ReorderableListView.builder(
                onReorder: (int oldIndex, int newIndex) {
                  context.read<PropertiesViewCubit>().editOrder(oldIndex, newIndex);
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: properties.length,
                itemBuilder: (context, position){
                  final Property property = properties[position];
                  return Card(
                    key: Key('$position'),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, editPropertiesRoute, arguments: PropertyEditArgs(collectionId: widget.collectionId, property: property)).then((value)
                        {
                          if(value != null){
                            if(value is Property){
                              context.read<PropertiesViewCubit>().updatePropertyList(value);
                            }
                            else if(value is int){
                              context.read<PropertiesViewCubit>().removeProperty(value);
                            }
                          }
                        });
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
                                    property.isRequired! ? TextSpan(text: ', required') : TextSpan(),
                                  ]
                              )
                          ),
                        trailing: Icon(Icons.drag_handle, color: ColorsPalette.blueGrey
                        ),
                      ),
                    ),
                  );
                },
              )
            ) : Center(child: Text('No properties')),
            ) : loadingWidget(ColorsPalette.algalFuel)
          );
        }
      )
    );
  }
}


