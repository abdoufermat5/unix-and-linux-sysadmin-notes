# Chapter 3: Access Control and Rootly Powers

![sudo-sesame](./data/sudo-sesame.png)

## Standard UNIX Access Control

The standard UNIX access control model has remained largely unchanged for decades. With a few enhancements, it continues to be the default for general-purpose OS distributions. The scheme follows a few basic rules:

- Access control decisions depends on which user is attempting to perform an operation, or in some cases, on that user's membership in a UNIX group.
- Objects (e.g files and processes) have owners. Owners have broad (but not necessarily unrestricted) control over their objects.
- You own the objects you create.
- The special user account called "root" can act as the owner of any object.
- Only root can perform certain sensitive administrative operations.

