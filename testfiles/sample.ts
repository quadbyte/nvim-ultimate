// Sample TypeScript file for testing Neovim Ultimate Edition
// This file demonstrates syntax highlighting, LSP features, and more

interface User {
    id: number;
    name: string;
    email: string;
    role: 'admin' | 'user' | 'guest';
}

class UserService {
    private users: User[] = [];

    constructor() {
        this.users = [];
    }

    /**
     * Add a new user
     * @param user - The user to add
     * @returns The added user
     */
    addUser(user: User): User {
        this.users.push(user);
        return user;
    }

    /**
     * Get user by ID
     * @param id - The user ID
     * @returns The user or undefined
     */
    getUser(id: number): User | undefined {
        return this.users.find(u => u.id === id);
    }

    /**
     * Get all users
     * @returns Array of all users
     */
    getAllUsers(): User[] {
        return this.users;
    }

    /**
     * Filter users by role
     * @param role - The role to filter by
     * @returns Filtered users
     */
    getUsersByRole(role: User['role']): User[] {
        return this.users.filter(u => u.role === role);
    }
}

// Usage
const userService = new UserService();

userService.addUser({
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    role: 'admin',
});

userService.addUser({
    id: 2,
    name: 'Jane Smith',
    email: 'jane@example.com',
    role: 'user',
});

const admin = userService.getUser(1);
console.log(admin?.name);

const admins = userService.getUsersByRole('admin');
console.log('Admins:', admins.length);

export { UserService, User };
