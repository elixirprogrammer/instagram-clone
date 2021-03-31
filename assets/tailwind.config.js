const colors = require('tailwindcss/colors')

module.exports = {
  purge: {
    enabled: process.env.NODE_ENV === "production",
    content: [
      "../lib/**/*.eex",
      "../lib/**/*.leex",
      "../lib/**/*_view.ex"
    ],
    options: {
      whitelist: [/phx/, /nprogress/]
    }
  },
  theme: {
    extend: {
      colors: {
        'light-blue': colors.lightBlue,
        cyan: colors.cyan,
      },
    },
    customForms: (theme) => ({
      default: {
        checkbox: {
          "&:focus": {
            outline: "none",
            boxShadow: "none",
            borderColor: "none",
          },
        },
      },
    }),
  },
  variants: {
    extend: {
      borderWidth: ['hover'],
    }
  },
  plugins: [require('@tailwindcss/custom-forms')],
}
