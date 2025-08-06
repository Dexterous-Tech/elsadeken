import 'package:flutter/material.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 10,
                  left: 30,
                  child: Icon(
                    Icons.add,
                    color: Colors.orange.withOpacity(0.4),
                    size: 20,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Icon(
                    Icons.add,
                    color: Colors.orange.withOpacity(0.4),
                    size: 16,
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 40,
                  child: Icon(
                    Icons.add,
                    color: Colors.orange.withOpacity(0.4),
                    size: 18,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 50,
                  child: Icon(
                    Icons.add,
                    color: Colors.orange.withOpacity(0.4),
                    size: 14,
                  ),
                ),
                Transform.rotate(
                  angle: 0.2, 
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade300,
                          Colors.orange.shade500,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              'لا يوجد إشعارات حتى الآن',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'ستظهر إشعاراتك هنا عند وصول\nرسائل جديدة',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}