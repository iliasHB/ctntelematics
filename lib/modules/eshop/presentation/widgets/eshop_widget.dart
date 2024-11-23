import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../service_locator.dart';
import '../../domain/entitties/req_entities/token_req_entity.dart';
import '../bloc/eshop_bloc.dart';
import '../pages/eshop_page.dart';

class EshopWidget extends StatefulWidget {
  final String? token;
  const EshopWidget({super.key, this.token});

  @override
  State<EshopWidget> createState() => _EshopWidgetState();
}

class _EshopWidgetState extends State<EshopWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eshop', style: AppStyle.cardSubtitle),
      ),
      body: BlocProvider(
        create: (_) => sl<EshopGetAllProductBloc>()
          ..add(EshopGetProductsEvent(
              EshopTokenReqEntity(token: widget.token ?? ""))),
        child: BlocConsumer<EshopGetAllProductBloc, EshopState>(
          builder: (context, state) {
            if (state is EshopLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              );
            } else if (state is EshopGetProductsDone) {
              // Check if the schedule data is empty
              if (state.resp.products.data == null || state.resp.products.data.isEmpty) {
                return Center(
                  child: Text(
                    'No available product',
                    style: AppStyle.cardfooter,
                  ),
                );
              }

              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.resp.products.data.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      childAspectRatio: 0.92, // Adjust for width-to-height ratio
                      mainAxisSpacing: 0, // Removes vertical spacing
                      crossAxisSpacing: 0, // Removes horizontal spacing
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return AllProduct(
                        productName: state.resp.products.data[index].name,
                        productImage: state.resp.products.data[index].image,
                        price: state.resp.products.data[index].price.toString(),
                        onAddToCart: () {},
                        onFavorite: () {},
                          categoryId: state.resp.products.data[index].category_id
                              .toString(),
                          description:
                          state.resp.products.data[index].description,
                          token: widget.token!

                      );
                    },
                  )
                ],
              );

            } else {
              return Center(
                  child: Text(
                    'No records found',
                    style: AppStyle.cardfooter,
                  ));
            }
          },
          listener: (context, state) {
            if (state is EshopFailure) {
              if (state.message.contains("401")) {
                Navigator.pushNamed(context, "/login");
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      )
    );
  }
}
