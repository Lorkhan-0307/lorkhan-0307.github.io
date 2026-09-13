export function toc() {
  const wrapper = document.getElementById('toc-wrapper');
  if (wrapper && document.querySelector('main h2, main h3')) {
    // see: https://github.com/tscanlin/tocbot#usage
    tocbot.init({
      tocSelector: '#toc',
      contentSelector: '.content',
      ignoreSelector: '[data-toc-skip]',
      headingSelector: 'h2, h3, h4',
      orderedList: false,
      scrollSmooth: false
    });

    wrapper.classList.remove('d-none');
  }
}
