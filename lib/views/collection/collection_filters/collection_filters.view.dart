
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_iconpicker/extensions/list_extensions.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/models/collection_item.model.dart';
import 'package:rateit/models/collection_property.model.dart';
import 'package:rateit/views/collection/collection_filters/cubit/collection_filters_cubit.dart';

class CollectionFiltersView extends StatefulWidget {

  const CollectionFiltersView();

  @override
  _CollectionFiltersViewState createState() => _CollectionFiltersViewState();
}

class _CollectionFiltersViewState extends State<CollectionFiltersView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollectionFiltersCubit, CollectionFiltersState>(
        listener: (context, state){
          if(state is CollectionFiltersApplied){
            globalScaffoldMessenger.currentState!
                .hideCurrentSnackBar();
            Navigator.pop(context, state.collection);
          }
        },
        child: BlocBuilder<CollectionFiltersCubit, CollectionFiltersState>(
          builder: (context, state){
            return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: Text('Filters'),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
              persistentFooterButtons: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  resetButton(context),
                  submitButton(context, state.collection, state.properties)
                ],)

              ],
              body: Container(
                padding: EdgeInsets.only(left: viewPadding, right: viewPadding, bottom: formBottomPadding),
                child: SingleChildScrollView(child: FormBuilder(
                key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(height: sizerHeightsm),
                Text("Rating:", style: appTextStyle(fontSize: accentFontSize),),
                FormBuilderRangeSlider(
                  name: "rating",
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  initialValue: RangeValues(0.0, 5.0),
                  maxValueWidget: (max) => TextButton(
                    onPressed: () {
                      _formKey.currentState?.patchValue({
                        'rating': const RangeValues(5, 5),
                      });
                    },
                    child: Text(max),
                  ),
                  activeColor: ColorsPalette.boyzone,
                  inactiveColor: ColorsPalette.lynxWhite
                ),
                SizedBox(height: sizerHeightMd),
                state is CollectionFiltersSuccess ? 
                (state.properties != null) ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.properties!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var property = state.properties![index];
                      String propertyName = property.name!;
                      String label = property.comment != null ? "$propertyName, ${property.comment}" : propertyName;
                      if(property.isDropdown! && property.dropdownOptions.isNotNullOrEmpty){
                        List<String> options = List.empty(growable: true);
                        options.add("All");
                        options.addAll(property.dropdownOptions!);
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(label, style: appTextStyle(fontSize: accentFontSize, weight: FontWeight.bold),),
                          FormBuilderDropdown<String>(
                            name: propertyName,
                            initialValue: options.first,
                            items: options
                                .map((value) => DropdownMenuItem(
                              alignment: AlignmentDirectional.centerStart,
                              value: value,
                              child: Text(value),
                            )).toList(),
                            valueTransformer: (val) => val?.toString(),
                          ),
                          SizedBox(height: sizerHeightMd)
                        ]);
                      }else if(property.type == "Date"){
                        return Column(children: [
                          FormBuilderDateTimePicker(
                            name: propertyName,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            initialValue: DateTime.now(),
                            inputType: InputType.both,
                            decoration: InputDecoration(
                              labelText: propertyName,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  //_formKey.currentState!.fields['date']?.didChange(null);
                                },
                              ),
                            ),
                            initialTime: const TimeOfDay(hour: 8, minute: 0),
                            // locale: const Locale.fromSubtags(languageCode: 'fr'),
                          )
                        ],);}
                      else if(property.type == "Number"){
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(label, style: appTextStyle(fontSize: accentFontSize, weight: FontWeight.bold),),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            SizedBox(width: width40, child:
                            FormBuilderTextField(
                              name: "${propertyName}minValue",
                              initialValue: property.minValue != null ? property.minValue.toString() : "0",
                              decoration: const InputDecoration(labelText: 'From'),
                              keyboardType: TextInputType.number,
                            )),
                            SizedBox(width: width40, child:
                            FormBuilderTextField(
                              name: "${propertyName}maxValue",
                              initialValue: property.maxValue != null ? property.maxValue.toString() : "",
                              decoration: const InputDecoration(labelText: 'To'),
                              keyboardType: TextInputType.number,
                            )),
                          ],),
                          SizedBox(height: sizerHeightMd),
                        ],);
                      }
                      else{
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(label, style: appTextStyle(fontSize: accentFontSize, weight: FontWeight.bold),),
                          FormBuilderTextField(
                            name: propertyName,
                            keyboardType: TextInputType.text,
                            initialValue: property.value
                          ),
                          SizedBox(height: sizerHeightMd)
                        ]);
                      }
                    }
                ) : SizedBox() : loadingWidget(ColorsPalette.algalFuel)
              ]))),
              ),
            );
          }
        )
    );
  }

  Widget submitButton(BuildContext context, Collection collection, List<CollectionProperty>? props) => OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
        ),
        backgroundColor: ColorsPalette.algalFuel,
        foregroundColor: ColorsPalette.white,
        side: BorderSide(color: ColorsPalette.algalFuel),
      ),
      onPressed: (){
        if(collection != null){
          var isFormValid = _formKey.currentState!.validate();

          if(isFormValid){
            if(props != null && props.isNotEmpty){
              List<CollectionProperty> properties = List.empty(growable: true);

              for (var prop in props) {
                if(prop.type == "Number"){
                  String? minValue = _formKey.currentState?.fields["${prop.name}minValue"]?.value;
                  String? maxValue = _formKey.currentState?.fields["${prop.name}maxValue"]?.value;
                  properties.add(prop.copyWith(
                      minValue: minValue != null && minValue.isNotEmpty ? int.tryParse(minValue) : 0,
                      maxValue: maxValue != null && maxValue.isNotEmpty ? int.tryParse(maxValue) : null));
                }else{
                  var value = _formKey.currentState?.fields[prop.name!]?.value;
                  if(value != null && value.toString().isNotEmpty){
                    properties.add(prop.copyWith(value: _formKey.currentState?.fields[prop.name!]?.value.toString()));
                  }
                }
              }

              var date =  _formKey.currentState?.fields['date']?.value;
              var ratingRange = _formKey.currentState?.fields['rating']?.value;

              context.read<CollectionFiltersCubit>().applyFilters(collection, properties, date, ratingRange);
            }

          }
        }
      },
      child: Text('Apply filters')
  );

  Widget resetButton(BuildContext context) => OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
        ),
        backgroundColor: ColorsPalette.desire,
        foregroundColor: ColorsPalette.white,
        side: BorderSide(color: ColorsPalette.desire),
      ),
      onPressed: (){
        Navigator.pop(context, 0);
      },
      child: Text('Reset filters')
  );
}