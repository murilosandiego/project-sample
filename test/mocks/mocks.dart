import 'package:faker/faker.dart';
import 'package:news_app/domain/entities/post.dart';
import 'package:news_app/domain/entities/user.dart';
import 'package:news_app/domain/value_objects/message.dart';
import 'package:news_app/presentation/pages/feed/post_view_model.dart';

const apiResponsePosts = """
[
  {
    "username": "username 1",
    "userId": 51,
    "content": "content 1",
    "createdAt": "2028-10-26T00:00:00",
    "id": "1"
  },
  {
    "username": "username 2",
    "userId": 22,
    "content": "content 2",
    "createdAt": "2048-10-30T00:00:00",
    "id": "2"
  }   
]
""";

List<PostEntity> newsList = [
  PostEntity(
    id: 1,
    message: Message(
      content: 'Message 1',
      createdAt: DateTime(2020, 01, 20),
    ),
    user: User(
      name: 'user1',
      id: 21,
    ),
  ),
  PostEntity(
    id: 2,
    message: Message(
      content: 'Message 2',
      createdAt: DateTime(2018, 01, 14),
    ),
    user: User(
      name: 'user2',
      id: 22,
    ),
  ),
];

final postsViewModel = newsList
    .map(
      (post) => NewsViewModel(
        id: post.id,
        message: post.message.content,
        date:
            'January ${post.message.createdAt.day}, ${post.message.createdAt.year}',
        user: post.user.name,
        userId: post.user.id,
      ),
    )
    .toList();

final postsViewModelEdited = List.of(postsViewModel)
    .map((e) => e.id == 2 ? e.copyWith(message: 'Editada') : e)
    .toList();

final mockPost = PostEntity(
  id: faker.randomGenerator.integer(10),
  message: Message(
    content: faker.lorem.sentence(),
    createdAt: DateTime(1997, 01, 31),
  ),
  user: User(
    name: faker.person.name(),
    id: faker.randomGenerator.integer(10),
  ),
);

const factoryApiResponse = """
{
  "token": "token 1",
  "username": "username 1",
  "email": "email 1",
  "id": "1"
 }
""";

const factoryNewPostApiResponse = """
 {
  "username": "username 1",
  "userId": 51,
  "content": "content 1",
  "createdAt": "2028-10-26T01:58:26.337Z",
  "id": "1"
 }
""";
