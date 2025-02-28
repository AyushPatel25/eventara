import 'package:eventapp/componets/org_textfield.dart';
import 'package:flutter/material.dart';

import '../../componets/text_field.dart';
import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class CreateEvent extends StatelessWidget {
  const CreateEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              title: TextStyleHelper.CustomText(
                text: 'Create event',
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 25,
                fontFamily: Assets.fontsPoppinsBold,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 190,
                      width: 50,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.lightGrey,
                    ),
                        // child: ClipRRect(
                        // borderRadius: BorderRadius.circular(25),
                        // child: FadeInImage(
                        // placeholder:
                        // AssetImage("assets/images/placeholder.png"),
                        // image: NetworkImage(event.eventImage),
                        // fit: BoxFit.cover,
                        // imageErrorBuilder: (context, error, stackTrace) {
                        // return Center(
                        // child: Icon(Icons.error,
                        // color: Colors.red,
                        // size: 50),
                        // );
                        // },
                    ),
                    const SizedBox(height: 15,),

                    OrgTextfield(
                      label: "Title",
                      hintText: "Enter title",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),

                    OrgTextfield(
                      label: "Event Date",
                      hintText: "Enter event date",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Time",
                      hintText: "Enter event time",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Location",
                      hintText: "Enter location",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                        cursorColor: AppColors.whiteColor,
                        maxLines: 4,
                        minLines: 3,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.lightGrey),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.lightGrey),),
                          hintText: "Write your event description",
                          hintStyle: TextStyle(color: AppColors.lightGrey,
                              fontFamily: 'regular'),
                          labelText: "Description",
                          labelStyle: TextStyle(
                            color: AppColors.lightGrey,
                            fontFamily: 'regular',),
                          filled: true,
                          fillColor: AppColors.greyColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.lightGrey),
                          ),
                        ),
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Language",
                      hintText: "Enter language",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Duration",
                      hintText: "Enter duration (Ex: 3 Hours)",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Age limit",
                      hintText: "Enter age limit",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Category",
                      hintText: "Enter language",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Arrangement",
                      hintText: "Enter language",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Latitude",
                      hintText: "Enter latitude",
                      //controller:,
                    ),
                    const SizedBox(height: 10,),
                    OrgTextfield(
                      label: "Longitude",
                      hintText: "Enter longitude",
                      //controller:,
                    ),
                  ],
                ),
              ),

            ),

          ],
        ),
      ),
    );
  }
}
