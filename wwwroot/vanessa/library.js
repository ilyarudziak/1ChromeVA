var customDrawElements = [];

function getActiveElement() {
    let activeElement = document.activeElement;
    let selectedField = undefined;

    if (activeElement.classList.contains('gridBody')) {
        selectedField = activeElement.querySelector('.select.focus');
    } else if (activeElement.classList.contains('frameCommand')) {
        selectedField = activeElement.querySelector('.focus');
    } else if (activeElement.classList.contains('cloud' && 'panelsShadow')) {
        selectedField = activeElement.querySelector('.select');
    } else if (activeElement.classList.contains('cloud' && 'cloudBorder')) {
        selectedField = activeElement.querySelector('.select');
    }

    return selectedField ? selectedField : activeElement;
}

function selected() {
    return getActiveElement();
}

function elem(id) {
    let element = $('span.framePress:visible').filter((i, e) => e.firstChild.id.endsWith('_' + id))[0];
    if (!element) element = $('label.field:visible').filter((i, e) => (e.id.endsWith('_' + id)))[0];
    return element;
}

function theme(title) {
    return $('span.themeBoxName:visible').filter((i, e) => ($(e.firstChild).text() == title))[0];
}

function command(title) {
    return $('div.funcCmdTxt:visible').filter((i, e) => ($(e.firstChild).text() == title))[0];
}

function page(id) {
    return $('div.tabsItem:visible').filter((i, e) => e.id.endsWith('_' + id))[0];
}

function fullscreen(mode) {

    var elem = document.documentElement;

    function openFullscreen() {
        if (elem.requestFullscreen) {
            elem.requestFullscreen();
        } else if (elem.mozRequestFullScreen) { /* Firefox */
            elem.mozRequestFullScreen();
        } else if (elem.webkitRequestFullscreen) { /* Chrome, Safari and Opera */
            elem.webkitRequestFullscreen();
        } else if (elem.msRequestFullscreen) { /* IE/Edge */
            elem.msRequestFullscreen();
        }
    }

    function closeFullscreen() {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.mozCancelFullScreen) { /* Firefox */
            document.mozCancelFullScreen();
        } else if (document.webkitExitFullscreen) { /* Chrome, Safari and Opera */
            document.webkitExitFullscreen();
        } else if (document.msExitFullscreen) { /* IE/Edge */
            document.msExitFullscreen();
        }
    }

    if (mode) {
        openFullscreen();
    } else {
        closeFullscreen();
    }
}

function border(id, timeout = 3000, options = undefined) {
    let px = value => (typeof(value) == 'number' ? value + 'px' : value);
    let style = {
        color: "red",
        style: "solid",
        size: 2,
        margin: 4,
    };
    Object.assign(style, options);
    let coordinates = id;
    if (typeof(id) == "string") {
        let element = elem(id);
        if (!element) return;
        let rect = element.getBoundingClientRect();
        coordinates = {
            left: rect.left - (style.margin + style.size),
            top: rect.top - (style.margin + style.size),
            width: rect.width + style.margin * 2,
            height: rect.height + style.margin * 2,
        }
    }
    let node = document.createElement('div');
    node.style.position = 'fixed';
    node.style.zIndex = 999999;
    node.style.left = px(coordinates.left);
    node.style.top = px(coordinates.top);
    node.style.width = px(coordinates.width);
    node.style.height = px(coordinates.height);
    node.style.borderWidth = px(style.size);
    node.style.borderStyle = style.style;
    node.style.borderColor = style.color;
    window.top.document.body.appendChild(node);
    if (timeout) setTimeout(() => { if (node) node.remove() }, timeout);
    customDrawElements.push(node);
    return node;
}

function rect(text, timeout = 3000, options = undefined) {
    let px = value => (typeof(value) == 'number' ? value + 'px' : value);
    let node = document.createElement('div');
    node.innerHTML = text;
    node.style.fontSize = '140%';
    node.style.position = 'fixed';
    node.style.zIndex = 999999;
    node.style.top = '3em';
    node.style.right = '3em';
    node.style.borderWidth = '0.2em';
    node.style.borderStyle = 'solid';
    node.style.borderColor = 'red';
    node.style.boxShadow = '0 0 1em #333333';
    node.style.backgroundColor = 'white';
    node.style.padding = '1em';
    node.style.borderRadius = '1em';
    window.top.document.body.appendChild(node);
    if (timeout) setTimeout(() => { if (node) node.remove() }, timeout);
    customDrawElements.push(node);
    return node;
};

function arrow(start, end, timeout = 3000, options = undefined) {
    function point(id) {
        if ((id) instanceof Element) return id;
        if (typeof(id) == "string") return elem(id);
        if (typeof(id) == "object") return LeaderLine.pointAnchor(document.body, id);
    }
    let node = new LeaderLine(point(start), point(end), options);
    if (timeout) setTimeout(() => { if (node) node.remove() }, timeout);
    customDrawElements.push(node);
    $('.leader-line').css('z-index', 9999);
    return node;
}

function clear() {
    while (customDrawElements.length) {
        let node = customDrawElements.pop().remove();
        if (node) node.remove();
    }
}

function center() {
    return LeaderLine.pointAnchor(document.body, { x: "50%", y: "50%" });
}