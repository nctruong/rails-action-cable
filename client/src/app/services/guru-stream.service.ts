import { Injectable } from '@angular/core';
import { ActionCableService, Channel } from 'angular2-actioncable';
import {environment as env} from '../../environments/environment';
import {Subscription} from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class GuruStreamService {
    subscription: Subscription;
    channel: Channel;
    jobSlug = null;

    constructor(private cableService: ActionCableService) {
    }

    subscribe(jobSlug: string, callback): void {
        if (this.channel || jobSlug == null) { return }
        this.jobSlug = jobSlug;
        this.createChannel();
        this.createSubscription(callback);
    }

    disConnect(): void {
        if (this.channel) {
            this.cableService.disconnect(env.socketUrl);
        }
    }

    get subscribed(): boolean {
        return this.subscription != null;
    }

    private createChannel(): void {
        this.channel = this.cableService
            .cable(env.socketUrl)
            .channel('GuruChannel', {job_slug: this.jobSlug });
    }

    private createSubscription(callback): void {
        this.subscription = this.channel.received().subscribe(message => {
            callback(message);
        });
    }
}
