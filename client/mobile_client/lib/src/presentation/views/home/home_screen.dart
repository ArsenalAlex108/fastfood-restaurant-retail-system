import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/router/app_route_constants.dart';
import '../admin/admin_home_screen.dart';
import '/src/logic/blocs/admin/admin_add_offers/four-images-offer/admin_four_image_offer_cubit.dart';
import '/src/logic/blocs/home_blocs/carousel_bloc/carousel_image_bloc.dart';
import '/src/logic/blocs/user_cubit/user_cubit.dart';
import '/src/presentation/widgets/common_widgets/custom_app_bar.dart';
import '/src/presentation/widgets/home/address_bar.dart';
import '/src/presentation/widgets/home/carousel_image.dart';
import '/src/presentation/widgets/home/deal_of_the_day.dart';
import '/src/presentation/widgets/home/multi_image_offer.dart';
import '/src/presentation/widgets/home/top_categories.dart';
import '/src/utils/constants/constants.dart';
import '/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CarouselImageBloc>(context).add(ResetCarouselEvent());
    context
        .read<AdminFourImageOfferCubit>()
        .adminGetFourImagesOffer(isUser: true);

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is UserSuccessS) {
                    return state.user.address == ''
                        ? const SizedBox()
                        : const AddressBar();
                  }
                  return const SizedBox();
                },
              ),
              const TopCategories(),
              CarouselImage(),
              Container(
                decoration:
                    const BoxDecoration(gradient: Constants.goldenGradient),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DealOfTheDay(),
                      const SizedBox.square(dimension: 8),
                      BlocConsumer<AdminFourImageOfferCubit,
                          AdminFourImageOfferState>(
                        listener: (context, state) {
                          if (state is AdminFourImageOfferErrorS) {
                            showSnackBar(context, state.errorString);
                          }
                        },
                        builder: (context, state) {
                          if (state is AdminGetFourImageOfferSuccessS) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.fourImagesOfferList.length,
                                itemBuilder: ((context, index) {
                                  final offer =
                                      state.fourImagesOfferList[index];

                                  return MultiImageOffer(
                                    title: offer.title,
                                    category: offer.category,
                                    images: offer.images,
                                    labels: offer.labels,
                                  );
                                }));
                          } else {
                            context
                                .read<AdminFourImageOfferCubit>()
                                .adminGetFourImagesOffer(isUser: true);
                            return SizedBox(
                              height: MediaQuery.sizeOf(context).height / 1.2,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
