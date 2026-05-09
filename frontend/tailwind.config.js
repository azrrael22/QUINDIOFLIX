/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        brand: {
          50:  '#faf5ff',
          100: '#f3e8ff',
          400: '#c084fc',
          500: '#a855f7',
          600: '#9333ea',
          700: '#7e22ce',
          900: '#3b0764',
        },
      },
      boxShadow: {
        'card': '0 1px 3px rgba(0,0,0,0.4), 0 1px 2px rgba(0,0,0,0.3)',
        'card-hover': '0 10px 30px rgba(168,85,247,0.15), 0 4px 12px rgba(0,0,0,0.4)',
        'modal': '0 25px 60px rgba(0,0,0,0.7)',
      },
    },
  },
  plugins: [],
}
