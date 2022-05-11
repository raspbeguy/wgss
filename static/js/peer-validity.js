function validate_pubkey() {
  var pubkeyInput = document.getElementById('pubkey');
  var pubkeyHelp = document.getElementById('pubkeyHelp');
  const pubkeyRegex = /^[A-Za-z0-9+\/]{42}[A|E|I|M|Q|U|Y|c|g|k|o|s|w|4|8|0]=$/;
  if (pubkeyRegex.test(pubkeyInput.value)) {
    if (peers.map(function(e) {return e.pubkey}).includes(pubkeyInput.value)) {
      pubkeyInput.classList.remove("is-success");
      pubkeyInput.classList.add("is-danger");
      pubkeyHelp.classList.remove("is-success");
      pubkeyHelp.classList.add("is-danger");
      pubkeyHelp.innerHTML = "Cette clef est déjà déclarée.";
      return false;
    } else {
      pubkeyInput.classList.remove("is-danger");
      pubkeyInput.classList.add("is-success");
      pubkeyHelp.classList.remove("is-danger");
      pubkeyHelp.classList.add("is-success");
      pubkeyHelp.innerHTML = "Cette clef est valide.";
      return true;
    }
  } else {
    pubkeyInput.classList.remove("is-success");
    pubkeyInput.classList.add("is-danger");
    pubkeyHelp.classList.remove("is-success");
    pubkeyHelp.classList.add("is-danger");
    pubkeyHelp.innerHTML = "Cela ne ressemble pas à une clef.";
    return false;
  }
}

function validate_name() {
  var nameInput = document.getElementById('name');
  var nameHelp = document.getElementById('nameHelp');
  const nameRegex = /^[a-zA-Z\d\-_\s]+$/
  if (nameRegex.test(nameInput.value)) {
    if (peers.map(function(e) {return e.name}).includes(nameInput.value)) {
      nameInput.classList.remove("is-success");
      nameInput.classList.add("is-danger");
      nameHelp.classList.remove("is-success");
      nameHelp.classList.add("is-danger");
      nameHelp.innerHTML = "Ce nom est déjà pris.";
      return false;
    } else {
      nameInput.classList.remove("is-danger");
      nameInput.classList.add("is-success");
      nameHelp.classList.remove("is-danger");
      nameHelp.classList.add("is-success");
      nameHelp.innerHTML = "Ce nom est valide.";
      return true;
    }
  } else {
    nameInput.classList.remove("is-success");
    nameInput.classList.add("is-danger");
    nameHelp.classList.remove("is-success");
    nameHelp.classList.add("is-danger");
    nameHelp.innerHTML = "Uniquement des caractères alphanumériques, \"-\", \"_\" et des espaces.";
    return false;
  }
}

function validate_peer() {
  var pubkeyOK = validate_pubkey();
  var nameOK = validate_name();
  return pubkeyOK && nameOK;
}
