import 'package:flutter/material.dart';

class ProfileCircleAvatar extends StatelessWidget {
  const ProfileCircleAvatar(
      {Key? key,
      required this.imageUrl,
      required this.radius,
      required this.gender})
      : super(key: key);
  final String? imageUrl, gender;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: imageUrl == null
            ? Image.asset(
                gender == 'male'
                    ? 'assets/images/male.jpg'
                    : 'assets/images/female.jpg',
                fit: BoxFit.fill,
              )
            : FadeInImage.assetNetwork(
                placeholder: gender == 'male'
                    ? 'assets/images/male.jpg'
                    : 'assets/images/female.jpg',
                image: imageUrl!,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    gender == 'male'
                        ? 'assets/images/male.jpg'
                        : 'assets/images/female.jpg',
                    fit: BoxFit.fill,
                  );
                },
                fit: BoxFit.fill,
              ),
      ),
    );
  }
}
