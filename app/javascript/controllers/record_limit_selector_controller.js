import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="record-limit-selector"
export default class extends Controller {
  static values = { param: String };

  change(event) {
    const newLimit = event.target.value;
    const url = new URL(window.location.href);

    url.searchParams.delete("page");
    url.searchParams.set("limit", newLimit);

    Turbo.visit(url.toString());
  }
}
