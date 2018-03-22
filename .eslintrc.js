// https://eslint.org/docs/user-guide/configuring

module.exports = {
	root: true,
	parser: 'babel-eslint',
	parserOptions: {
		sourceType: 'module'
	},
	env: {
		browser: true,
	},
	extends: 'standard',
	// required to lint *.vue files
	plugins: [
		'html'
	],
	// add your custom rules here
	'rules': {
		'indent': [2, 'tab', { 'SwitchCase': 1, 'VariableDeclarator': 1 }],
		'no-tabs': 0,
		'comma-dangle': ["error", "always-multiline"],
		'semi': ["error", "always"],
		'console': [process.env.NODE_ENV === 'production' ? 'warn' : 0],
		// allow optionalDependencies
		'import/no-extraneous-dependencies': ['error', {
			'optionalDependencies': ['test/unit/index.js']
		}],
		// allow debugger during development
		'no-debugger': process.env.NODE_ENV === 'production' ? 2 : 0
	}
};
