# Contributing to CheckList

Thank you for your interest in contributing to CheckList! We welcome contributions from the community.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue on GitHub with:
- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Your environment (OS, Flutter version, etc.)

### Suggesting Features

We love new ideas! To suggest a feature:
- Check if the feature already exists in TODO.md
- Create an issue with a clear description of the feature
- Explain why this feature would be useful
- Provide examples if possible

### Pull Requests

1. **Fork the repository** and create your branch from `development`
2. **Make your changes** following our coding standards
3. **Test your changes** thoroughly
4. **Update documentation** if needed
5. **Create a pull request** with a clear description

### Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/AIGamer28100/CheckList.git
   cd CheckList
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up Firebase configuration (see README.md)

4. Run the app:
   ```bash
   flutter run
   ```

### Coding Standards

- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Add comments for complex logic
- Keep functions small and focused
- Use meaningful variable names

### Commit Message Format

```
type: subject

body (optional)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Example:
```
feat: add multi-provider account linking

Implemented Google and Email/Password linking with safety checks
and comprehensive error handling.
```

### Branch Naming

- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Documentation: `docs/description`

### Testing

- Write tests for new features
- Ensure all tests pass before submitting PR
- Run `flutter test` to execute tests

### Code Review

All submissions require code review. We use GitHub pull requests for this purpose.

## Community Guidelines

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Follow the code of conduct

## Questions?

If you have questions, feel free to:
- Open an issue for discussion
- Ask in pull request comments
- Contact the maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing to CheckList! 🎉
