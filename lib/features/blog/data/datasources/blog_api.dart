// File: lib/features/blog/data/datasources/success_story_api.dart



import '../../domain/entities/blog.dart';
import '../../domain/repository/blog_repo.dart';
import '../models/blog_model.dart';

class BlogApi implements BlogRepo{
  @override
  Future<List<Blog>> getBlogs() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return [
      BlogModel(
        imageUrl: 'assets/images/blog/wedd.png',
        title: 'الزواج بلا خوف: كيف تتخلص من الرهاب الاجتماعي؟',
        content: 'رهاب الزواج او جوموفوبيا الزواج كلها مصطلحات ربما سمعت عنها من قبل او شعرت بأعراضها وربما أثرت على حالتك اك العاطفية من شريك حساتك أو قد تكون منعتك من إكمال خطوة الزواج لذلك أعددنا هذا المقال ',
      ),
      BlogModel(
        imageUrl: 'assets/images/blog/wedd.png',
        title: 'الزواج بلا خوف: كيف تتخلص من الرهاب الاجتماعي؟',
        content: 'رهاب الزواج او جوموفوبيا الزواج كلها مصطلحات ربما سمعت عنها من قبل او شعرت بأعراضها وربما أثرت على حالتك اك العاطفية من شريك حساتك أو قد تكون منعتك من إكمال خطوة الزواج لذلك أعددنا هذا المقال ',
      ),
      BlogModel(
        imageUrl: 'assets/images/blog/wedd.png',
        title: 'الزواج بلا خوف: كيف تتخلص من الرهاب الاجتماعي؟',
        content: 'رهاب الزواج او جوموفوبيا الزواج كلها مصطلحات ربما سمعت عنها من قبل او شعرت بأعراضها وربما أثرت على حالتك اك العاطفية من شريك حساتك أو قد تكون منعتك من إكمال خطوة الزواج لذلك أعددنا هذا المقال ',
      ),
      BlogModel(
        imageUrl: 'assets/images/blog/wedd.png',
        title: 'الزواج بلا خوف: كيف تتخلص من الرهاب الاجتماعي؟',
        content: 'رهاب الزواج او جوموفوبيا الزواج كلها مصطلحات ربما سمعت عنها من قبل او شعرت بأعراضها وربما أثرت على حالتك اك العاطفية من شريك حساتك أو قد تكون منعتك من إكمال خطوة الزواج لذلك أعددنا هذا المقال ',
      ),

    ];
  }
}
