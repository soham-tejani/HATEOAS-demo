# HATEOAS Driven REST APIs
## What is it?

[HATEOAS](https://restfulapi.net/hateoas) (Hypermedia as the Engine of Application State) allows the client to dynamically navigate to the appropriate resources by traversing the hypermedia links, which are in the API responses. This architecture keeps the links to navigation to the forward level or the backward level.
## Why is this needed?

This will help your integration clients who have integrated your APIs with third-party apps for navigating, i.e., if a user is on the registration details API then it should contain the links of the ticket, event, and organization of that registration.

## Normal behavior
Normally, we are only sending the navigating links for the pagination, like links for the first, next, prev, last, and self page.
1. This is the example of (index)
```json
{
    "data": [
        {
          // posts data
        }
    ],
    "meta": {
        "count": 1
    },
    "links": {
        "first": "https://api.demo.com/v1/users/{userId}/posts",
        "self": "https://api.demo.com/v1/users/{userId}/posts?page=2",
        "last": "https://api.demo.com/v1/users/{userId}/posts?page=4",
        "prev": "https://api.demo.com/v1/users/{userId}/posts?page=1",
        "next": "https://api.demo.com/v1/users/{userId}/posts?page=3"
    }
}
```
2. This is the example of (show)
```json
{
    "data": {
        // post data
    }
}
```
## Expected behaviour
Here we are already sending the links of the self link for the index pages, so it doesn’t make sense that index APIs needed any backward navigation links, i.e. for above example is the index of posts (/v1/users/{userId}/posts), it has the link of that specific user of this post is belongs, i.e /v1/users/{userId}.

So, we could add the backward navigation links to the details API (show). Like, we can add the new attribute, with the links of the modules of the current entity. I.e. the above post belongs to any specific user. So we could add the links of that entity in the response of any/one post.


1. Example of Show request
```json
{
    "data": {
        // post data
    },
    "links": {
        "self": { "href": "/v1/posts/{postId}" },
        "auther": { "href": "/v1/users/{userId}" }
    }
}
```
Thank you for reading!