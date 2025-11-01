"""Sample Python file for testing Neovim Ultimate Edition.

This module demonstrates syntax highlighting, LSP features, and more.
"""

from typing import List, Optional
from dataclasses import dataclass


@dataclass
class User:
    """Represents a user in the system."""

    id: int
    name: str
    email: str
    role: str = "user"

    def get_display_name(self) -> str:
        """Get the user's display name.

        Returns:
            str: The formatted display name.
        """
        return f"{self.name} <{self.email}>"

    def is_admin(self) -> bool:
        """Check if the user is an admin.

        Returns:
            bool: True if the user is an admin, False otherwise.
        """
        return self.role == "admin"


class UserService:
    """Service for managing users."""

    def __init__(self):
        """Initialize the user service."""
        self.users: List[User] = []

    def add_user(self, user: User) -> User:
        """Add a new user.

        Args:
            user: The user to add.

        Returns:
            User: The added user.
        """
        self.users.append(user)
        return user

    def get_user(self, user_id: int) -> Optional[User]:
        """Get a user by ID.

        Args:
            user_id: The ID of the user to retrieve.

        Returns:
            Optional[User]: The user if found, None otherwise.
        """
        for user in self.users:
            if user.id == user_id:
                return user
        return None

    def get_all_users(self) -> List[User]:
        """Get all users.

        Returns:
            List[User]: List of all users.
        """
        return self.users

    def get_users_by_role(self, role: str) -> List[User]:
        """Filter users by role.

        Args:
            role: The role to filter by.

        Returns:
            List[User]: Filtered list of users.
        """
        return [u for u in self.users if u.role == role]


# Usage
if __name__ == "__main__":
    service = UserService()

    # Add users
    service.add_user(User(id=1, name="John Doe", email="john@example.com", role="admin"))
    service.add_user(User(id=2, name="Jane Smith", email="jane@example.com"))

    # Get user
    admin = service.get_user(1)
    if admin:
        print(admin.get_display_name())

    # Get admins
    admins = service.get_users_by_role("admin")
    print(f"Admins: {len(admins)}")
